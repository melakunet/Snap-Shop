interface SentryEvent {
  error: Error
  route: string
  extras?: Record<string, unknown>
}

function parseDSN(dsn: string): { storeUrl: string; authHeader: string } | null {
  try {
    const url = new URL(dsn)
    const publicKey = url.username
    const host = url.hostname
    const projectId = url.pathname.replace('/', '')
    return {
      storeUrl: `https://${host}/api/${projectId}/store/`,
      authHeader: `Sentry sentry_version=7, sentry_client=snap-shop-api/1.0, sentry_key=${publicKey}`,
    }
  } catch {
    return null
  }
}

// Fire-and-forget; never propagates. Excludes image bytes and user content.
export async function captureError(dsn: string, event: SentryEvent): Promise<void> {
  const parsed = parseDSN(dsn)
  if (!parsed) return

  try {
    await fetch(parsed.storeUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Sentry-Auth': parsed.authHeader,
      },
      body: JSON.stringify({
        event_id: crypto.randomUUID().replace(/-/g, ''),
        timestamp: new Date().toISOString(),
        platform: 'node',
        level: 'error',
        exception: {
          values: [{ type: event.error.name, value: event.error.message }],
        },
        tags: { route: event.route },
        extra: event.extras,
      }),
    })
  } catch {
    // Never let Sentry failures affect the response
  }
}
