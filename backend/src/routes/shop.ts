import { Hono } from 'hono'
import type { Env, Variables } from '../lib/schema'
import { ShopRequest } from '../lib/schema'
import { errorBody } from '../lib/errors'
import { fetchShoppingResults } from '../services/serpapi'
import { captureError } from '../lib/sentry'

const route = new Hono<{ Bindings: Env; Variables: Variables }>()

// POST /shop — SerpAPI google_shopping with retailer whitelist filtering
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

  try {
    const results = await fetchShoppingResults(query, retailer_whitelist, c.env)
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
