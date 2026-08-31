import { Link } from 'react-router'

import { FormField } from '@/components/FormField'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { useResendConfirmation } from '@/hooks/useResendConfirmation'

export function ResendConfirmation() {
  const { form, onSubmit, loading, submitted } = useResendConfirmation()
  const {
    register,
    formState: { errors },
  } = form

  if (submitted) {
    return (
      <Card className="mx-auto w-full max-w-sm">
        <CardHeader>
          <CardTitle>Check your email</CardTitle>
          <CardDescription>
            If an unconfirmed account exists for that address, we&apos;ve sent a new confirmation link.
          </CardDescription>
        </CardHeader>
      </Card>
    )
  }

  return (
    <Card className="mx-auto w-full max-w-sm">
      <CardHeader>
        <CardTitle>Resend confirmation email</CardTitle>
        <CardDescription>Enter your email and we&apos;ll send you a new confirmation link</CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={onSubmit} className="flex flex-col gap-4">
          <FormField id="email" label="Email" error={errors.email?.message}>
            <Input id="email" type="email" {...register('email')} />
          </FormField>
          {errors.root && (
            <p role="alert" className="text-sm text-destructive">
              {errors.root.message}
            </p>
          )}
          <Button type="submit" disabled={loading}>
            Send confirmation email
          </Button>
          <p className="text-center text-sm text-muted-foreground">
            <Link to="/login" className="underline">
              Back to sign in
            </Link>
          </p>
        </form>
      </CardContent>
    </Card>
  )
}
