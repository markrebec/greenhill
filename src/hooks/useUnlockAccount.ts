import { useEffect, useRef, useState } from 'react'
import { useSearchParams } from 'react-router'

import { api, extractApiErrorMessage } from '@/lib/api'

type Status = 'loading' | 'success' | 'error'

export function useUnlockAccount() {
  const [searchParams] = useSearchParams()
  const token = searchParams.get('unlock_token')
  const [status, setStatus] = useState<Status>('loading')
  const [error, setError] = useState<string | null>(null)
  // The unlock request isn't idempotent (a token is single-use), so guard
  // against StrictMode's dev-mode double-invoke firing it twice.
  const firedRef = useRef(false)

  useEffect(() => {
    if (!token) {
      setStatus('error')
      setError('Missing unlock token.')
      return
    }

    if (firedRef.current) {
      return
    }
    firedRef.current = true

    api
      .get('users/unlock', { params: { unlock_token: token } })
      .then(() => setStatus('success'))
      .catch((err) => {
        setStatus('error')
        setError(extractApiErrorMessage(err, 'Could not unlock your account.'))
      })
  }, [token])

  return { status, error }
}
