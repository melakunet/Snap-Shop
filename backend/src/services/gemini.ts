import type { Env } from '../lib/schema'
import type { IdentifyResult } from './claude'

export async function identifyWithGemini(
  _imageBase64: string,
  _env: Env,
): Promise<IdentifyResult> {
  throw new Error('not implemented')
}
