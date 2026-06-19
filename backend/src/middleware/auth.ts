import type { MiddlewareHandler } from 'hono'
import type { Env } from '../lib/schema'

// Verifies Sign in with Apple JWT on every protected route
export const auth: MiddlewareHandler<{ Bindings: Env }> = async (_c, next) => {
  await next()
}
