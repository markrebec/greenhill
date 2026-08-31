import { Link } from 'react-router'

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { useUnlockAccount } from '@/hooks/useUnlockAccount'

export function UnlockAccount() {
  const { status, error } = useUnlockAccount()

  return (
    <Card className="mx-auto w-full max-w-sm">
      <CardHeader>
        <CardTitle>
          {status === 'loading' && 'Unlocking your account…'}
          {status === 'success' && 'Account unlocked'}
          {status === 'error' && 'Unlock failed'}
        </CardTitle>
        <CardDescription>
          {status === 'loading' && 'One moment while we unlock your account.'}
          {status === 'success' && 'Your account has been unlocked. You can now sign in.'}
          {status === 'error' && error}
        </CardDescription>
      </CardHeader>
      {status !== 'loading' && (
        <CardContent>
          <Link to="/login" className="text-sm underline">
            Back to sign in
          </Link>
        </CardContent>
      )}
    </Card>
  )
}
