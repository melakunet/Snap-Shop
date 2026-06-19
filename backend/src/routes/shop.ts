import { Hono } from 'hono'
import type { Env } from '../lib/schema'

const route = new Hono<{ Bindings: Env }>()

// GET /shop?q=<product> — SerpAPI google_shopping with Redis cache
route.get('/', async (c) => c.json({ message: 'not implemented' }, 501))

export default route
