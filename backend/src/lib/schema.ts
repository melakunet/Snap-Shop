import { z } from 'zod'

export const Env = z.object({
  ENVIRONMENT: z.string(),
  APPLE_BUNDLE_ID: z.string(),
  ANTHROPIC_API_KEY: z.string(),
  GEMINI_API_KEY: z.string(),
  SERPAPI_KEY: z.string(),
  UPSTASH_REDIS_REST_URL: z.string(),
  UPSTASH_REDIS_REST_TOKEN: z.string(),
  SENTRY_DSN: z.string(),
  PLAUSIBLE_DOMAIN: z.string(),
  DEV_AUTH_BYPASS: z.string().optional(),
})
export type Env = z.infer<typeof Env>

// Shared Hono context variables set by auth middleware
export type Variables = { userId: string }

// Product identification response shape
export const IdentifyResult = z.object({
  brand: z.string(),
  model: z.string(),
  category: z.string(),
  distinguishing_features: z.array(z.string()),
  confidence: z.number().min(0).max(1),
  search_query: z.string(),
})
export type IdentifyResult = z.infer<typeof IdentifyResult>
