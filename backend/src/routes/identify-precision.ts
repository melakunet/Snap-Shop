import { Hono } from 'hono'
import type { Env } from '../lib/schema'

const route = new Hono<{ Bindings: Env }>()

// POST /identify/precision — Claude Vision (Sonnet 4.6, Opus 4.7 on retry)
route.post('/', async (c) => c.json({ message: 'not implemented' }, 501))

export default route
