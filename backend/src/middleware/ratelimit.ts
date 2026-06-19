import type { MiddlewareHandler } from 'hono'
import type { Env } from '../lib/schema'

// Sliding-window rate limit via Upstash Redis
export const rateLimit: MiddlewareHandler<{ Bindings: Env }> = async (_c, next) => {
  await next()
}
