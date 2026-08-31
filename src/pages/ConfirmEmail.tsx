import { Link } from 'react-router'

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { useConfirmEmail } from '@/hooks/useConfirmEmail'

export function ConfirmEmail() {
  const { status, error } = useConfirmEmail()

  return (
    <Card className="mx-auto w-full max-w-sm">
      <CardHeader>
        <CardTitle>
          {status === 'loading' && 'Confirming your email…'}
          {status === 'success' && 'Email confirmed'}
          {status === 'error' && 'Confirmation failed'}
        </CardTitle>
        <CardDescription>
          {status === 'loading' && 'One moment while we confirm your email address.'}
          {status === 'success' && 'Your email has been confirmed. You can now sign in.'}
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
