import { useEffect, useRef, useState } from 'react'
import { useSearchParams } from 'react-router'

import { api, extractApiErrorMessage } from '@/lib/api'

type Status = 'loading' | 'success' | 'error'

export function useConfirmEmail() {
  const [searchParams] = useSearchParams()
  const token = searchParams.get('confirmation_token')
  const [status, setStatus] = useState<Status>('loading')
  const [error, setError] = useState<string | null>(null)
  // The confirm request isn't idempotent (a token is single-use), so guard
  // against StrictMode's dev-mode double-invoke firing it twice.
  const firedRef = useRef(false)

  useEffect(() => {
    if (!token) {
      setStatus('error')
      setError('Missing confirmation token.')
      return
    }

    if (firedRef.current) {
      return
    }
    firedRef.current = true

    api
      .get('users/confirmation', { params: { confirmation_token: token } })
      .then(() => setStatus('success'))
      .catch((err) => {
        setStatus('error')
        setError(extractApiErrorMessage(err, 'Could not confirm your email.'))
      })
  }, [token])

  return { status, error }
}
