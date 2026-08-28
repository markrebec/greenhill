import { type PropsWithChildren } from 'react'
import { Navigate, useLocation } from 'react-router'

import { useCurrentUser } from '@/hooks/useCurrentUser'

// Wrap a protected route. Redirects anonymous visitors to /login,
// preserving the originally-requested location so the login hook can send
// them back afterward. Renders nothing until the current-user check
// resolves, so it never redirects before we actually know.
export function Authenticated({ children }: PropsWithChildren) {
  const { user, loading } = useCurrentUser()
  const location = useLocation()

  if (loading) {
    return null
  }
  if (!user) {
    return <Navigate to="/login" state={{ from: location }} replace />
  }

  return <>{children}</>
}

// Wrap a guest-only route (login, register, forgot/reset password).
// Redirects already-signed-in visitors to the dashboard instead.
export function Unauthenticated({ children }: PropsWithChildren) {
  const { user, loading } = useCurrentUser()

  if (loading) {
    return null
  }
  if (user) {
    return <Navigate to="/dashboard" replace />
  }

  return <>{children}</>
}
