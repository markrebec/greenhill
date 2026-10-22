import { CombinedGraphQLErrors } from '@apollo/client/errors'
import type { FieldValues, Path, UseFormSetError } from 'react-hook-form'

type MutationError = { message: string; code?: string | null; path?: readonly string[] | null }

// Apollo Client v4 resolves a mutation with a single `error` (not an array)
// when errorPolicy is 'all' -- CombinedGraphQLErrors wraps the underlying
// GraphQL errors array when the server actually returned GraphQL errors;
// any other error (e.g. a network error) is a plain Error with a message.
function topLevelErrors(error: unknown): MutationError[] {
  if (!error) {
    return []
  }
  if (CombinedGraphQLErrors.is(error)) {
    return error.errors.map((e) => ({ message: e.message }))
  }
  return [{ message: error instanceof Error ? error.message : String(error) }]
}

// Merges top-level GraphQL errors and a mutation's own `errors` field
// (ClientError[] -- message/code/path) into one list, mapping each error's
// last path segment onto a react-hook-form field when it matches a known
// field (mirroring applyApiErrors' field -> messages[] mapping), else
// folding into `root`. Both error sources need checking in the same
// place -- a mutation can fail via either one, not just one or the other.
export function applyMutationErrors<T extends FieldValues>(
  error: unknown,
  mutationErrors: readonly MutationError[] | undefined,
  setError: UseFormSetError<T>,
  knownFields: readonly Path<T>[],
) {
  const merged = [...topLevelErrors(error), ...(mutationErrors ?? [])]
  const unmatched: string[] = []

  for (const mutationError of merged) {
    const field = mutationError.path?.at(-1)

    if (field && (knownFields as readonly string[]).includes(field)) {
      setError(field as Path<T>, { message: mutationError.message })
    } else {
      unmatched.push(mutationError.message)
    }
  }

  if (unmatched.length > 0) {
    setError('root', { message: unmatched.join('; ') })
  }
}
