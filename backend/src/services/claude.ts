import type { Env } from '../lib/schema'

export interface IdentifyResult {
  name: string
  brand: string
  confidence: number
  model_used: string
}

export async function identifyWithClaude(
  _imageBase64: string,
  _env: Env,
): Promise<IdentifyResult> {
  throw new Error('not implemented')
}
