export type ErrorCode =
  | 'unauthorized'
  | 'rate_limited'
  | 'invalid_input'
  | 'upstream_error'
  | 'internal'

export function errorBody(code: ErrorCode, message: string) {
  return { error: { code, message } }
}
