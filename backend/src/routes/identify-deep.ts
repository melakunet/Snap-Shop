import { Hono } from 'hono'
import type { Env } from '../lib/schema'

const route = new Hono<{ Bindings: Env }>()

// POST /identify/deep — Gemini Vision (2.5 Flash, 2.5 Pro on escalation)
route.post('/', async (c) => c.json({ message: 'not implemented' }, 501))

export default route
