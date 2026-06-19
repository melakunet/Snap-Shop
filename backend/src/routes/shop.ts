import { Hono } from 'hono'
import type { Env, Variables, ShopItem } from '../lib/schema'
import { ShopRequest } from '../lib/schema'
import { errorBody } from '../lib/errors'
import { fetchShoppingResults } from '../services/serpapi'
import { buildShopCacheKey, cacheGet, cacheSet } from '../services/cache'
import { captureError } from '../lib/sentry'

const route = new Hono<{ Bindings: Env; Variables: Variables }>()

// POST /shop — SerpAPI google_shopping with retailer whitelist + 1-hour cache
route.post('/', async (c) => {
  const userId = c.get('userId')

  let body: unknown
  try {
    body = await c.req.json()
  } catch {
    return c.json(errorBody('invalid_input', 'Expected JSON body'), 400)
  }

  const parsed = ShopRequest.safeParse(body)
  if (!parsed.success) {
    const msg = parsed.error.issues[0]?.message ?? 'Invalid request body'
    return c.json(errorBody('invalid_input', msg), 400)
  }

  const { query, retailer_whitelist } = parsed.data

  // Cache check — before SerpAPI, independent of any quota
  let cacheKey = ''
  try {
    cacheKey = await buildShopCacheKey(query, retailer_whitelist)
    const cached = await cacheGet<ShopItem[]>(cacheKey, c.env)
    if (cached !== null) {
      console.log(JSON.stringify({ cache: 'hit', key: cacheKey }))
      return c.json(cached)
    }
    console.log(JSON.stringify({ cache: 'miss', key: cacheKey }))
  } catch (err) {
    // Fail open: treat as miss, log to Sentry
    await captureError(c.env.SENTRY_DSN, {
      error: err instanceof Error ? err : new Error(String(err)),
      route: 'POST /shop cache-get',
      extras: { userId },
    })
  }

  try {
    const results = await fetchShoppingResults(query, retailer_whitelist, c.env)

    // Store result in cache (fire-and-forget on failure)
    if (cacheKey) {
      cacheSet(cacheKey, results, 3600, c.env).catch((err: unknown) => {
        void captureError(c.env.SENTRY_DSN, {
          error: err instanceof Error ? err : new Error(String(err)),
          route: 'POST /shop cache-set',
          extras: { userId },
        })
      })
    }

    return c.json(results)
  } catch (err) {
    const error = err instanceof Error ? err : new Error(String(err))
    await captureError(c.env.SENTRY_DSN, {
      error,
      route: 'POST /shop',
      extras: { userId },
    })
    return c.json(errorBody('upstream_error', 'Price lookup failed'), 502)
  }
})

export default route
