import type { Env, ShopItem } from '../lib/schema'

const SERPAPI_URL = 'https://serpapi.com/search'

interface SerpResult {
  price?: string
  extracted_price?: number
  delivery?: string
  source?: string
  link?: string
  thumbnail?: string
}

interface SerpAPIResponse {
  shopping_results?: SerpResult[]
  error?: string
}

export async function fetchShoppingResults(
  query: string,
  retailerWhitelist: string[],
  env: Env,
): Promise<ShopItem[]> {
  const params = new URLSearchParams({
    engine: 'google_shopping',
    q: query,
    api_key: env.SERPAPI_KEY,
    num: '40', // fetch extra before whitelist filtering
  })

  const res = await fetch(`${SERPAPI_URL}?${params}`)

  if (!res.ok) {
    const body = await res.text()
    throw new Error(`SerpAPI ${res.status}: ${body.slice(0, 300)}`)
  }

  const data = await res.json() as SerpAPIResponse

  if (data.error) throw new Error(`SerpAPI error: ${data.error}`)

  const results = data.shopping_results ?? []

  // Case-insensitive whitelist filter (empty whitelist = return all)
  const normalized = retailerWhitelist.map((r) => r.toLowerCase())
  const filtered = normalized.length === 0
    ? results
    : results.filter((r) =>
      r.source && normalized.some((w) => r.source!.toLowerCase().includes(w))
    )

  return filtered.slice(0, 10).map((r) => ({
    price: r.price ?? '',
    extracted_price: r.extracted_price ?? 0,
    delivery: r.delivery ?? '',
    source: r.source ?? '',
    link: r.link ?? '',
    thumbnail: r.thumbnail ?? '',
  }))
}
