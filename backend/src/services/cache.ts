import type { Env } from '../lib/schema'

export async function cacheGet<T>(_key: string, _env: Env): Promise<T | null> {
  throw new Error('not implemented')
}

export async function cacheSet(
  _key: string,
  _value: unknown,
  _ttlSeconds: number,
  _env: Env,
): Promise<void> {
  throw new Error('not implemented')
}
