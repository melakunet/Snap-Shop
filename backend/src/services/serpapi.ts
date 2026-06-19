import type { Env } from '../lib/schema'

export interface ShopResult {
  retailer: string
  title: string
  price: number
  currency: string
  url: string
}

export async function fetchPrices(
  _query: string,
  _env: Env,
): Promise<ShopResult[]> {
  throw new Error('not implemented')
}
