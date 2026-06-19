import type { MiddlewareHandler } from 'hono'
import type { Env, Variables } from '../lib/schema'

async function trackPlausible(
  domain: string,
  path: string,
  status: number,
  latencyMs: number,
): Promise<void> {
  try {
    await fetch('https://plausible.io/api/event', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'snap-shop-api/1.0',
        'X-Forwarded-For': '0.0.0.0',
      },
      body: JSON.stringify({
        domain,
        name: 'api_request',
        url: `https://${domain}${path}`,
        props: { path, status: String(status), latency_ms: String(latencyMs) },
      }),
    })
  } catch {
    // Never let analytics failures affect the response
  }
}

export const telemetry: MiddlewareHandler<{ Bindings: Env; Variables: Variables }> = async (c, next) => {
  const requestId = crypto.randomUUID()
  const startMs = Date.now()
  c.set('requestId', requestId)
  c.set('startMs', startMs)

  await next()

  const latencyMs = Date.now() - startMs
  console.log(JSON.stringify({
    requestId,
    method: c.req.method,
    path: c.req.path,
    status: c.res.status,
    latencyMs,
  }))

  if (c.env.PLAUSIBLE_DOMAIN) {
    void trackPlausible(c.env.PLAUSIBLE_DOMAIN, c.req.path, c.res.status, latencyMs)
  }
}
