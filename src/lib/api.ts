import axios from 'axios'
import type { FieldValues, Path, UseFormSetError } from 'react-hook-form'

// The page is always served by Rails (vite_rails), so API requests are
// always same-origin — no /api prefix or dev-server proxy needed.
export const api = axios.create({
  baseURL: '/',
  headers: { Accept: 'application/json' },
})

type ApiErrorData = { error?: string; errors?: Record<string, string[]> }

function apiErrorData(err: unknown): ApiErrorData | undefined {
  if (err && typeof err === 'object' && 'response' in err) {
    return (err as { response?: { data?: ApiErrorData } }).response?.data
  }
  return undefined
}

function humanize(field: string): string {
  return field.replace(/_/g, ' ').replace(/^\w/, (c) => c.toUpperCase())
}

// Maps a failed axios request (against Devise's JSON endpoints) onto a
// react-hook-form instance. Devise's two error shapes get handled
// differently: `{error: "..."}` (Warden auth failures, e.g. bad sign-in
// credentials) always becomes a form-level message; `{errors: {field:
// [...]}}` (ActiveModel validation failures) attaches to the matching
// field when the form actually has one, otherwise folds into the
// form-level message too (e.g. reset_password_token, which isn't a
// visible field — it comes from the URL).
export function applyApiErrors<T extends FieldValues>(
  err: unknown,
  setError: UseFormSetError<T>,
  knownFields: readonly Path<T>[],
  fallback: string,
) {
  const data = apiErrorData(err)

  if (data?.errors) {
    const unmatched: string[] = []

    for (const [field, messages] of Object.entries(data.errors)) {
      if ((knownFields as readonly string[]).includes(field)) {
        setError(field as Path<T>, { message: messages.join(', ') })
      } else {
        unmatched.push(`${humanize(field)} ${messages.join(', ')}`)
      }
    }

    if (unmatched.length > 0) {
      setError('root', { message: unmatched.join('; ') })
    }
    return
  }

  setError('root', { message: data?.error ?? fallback })
}

// Same error-shape handling as applyApiErrors, but for call sites with no
// form to attach field errors to (e.g. an auto-fired GET on page load) —
// just flattens whatever Devise sent back into one displayable string.
export function extractApiErrorMessage(err: unknown, fallback: string): string {
  const data = apiErrorData(err)

  if (data?.errors) {
    return Object.entries(data.errors)
      .map(([field, messages]) => `${humanize(field)} ${messages.join(', ')}`)
      .join('; ')
  }

  return data?.error ?? fallback
}
