import { Link } from 'react-router'

import { FormField } from '@/components/FormField'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { useRegister } from '@/hooks/useRegister'

export function Register() {
  const { form, onSubmit, loading, needsConfirmation } = useRegister()
  const {
    register,
    formState: { errors },
  } = form

  if (needsConfirmation) {
    return (
      <Card className="mx-auto w-full max-w-sm">
        <CardHeader>
          <CardTitle>Check your email</CardTitle>
          <CardDescription>
            We&apos;ve sent a confirmation link to your email address. Click it to confirm your account before signing
            in.
          </CardDescription>
        </CardHeader>
      </Card>
    )
  }

  return (
    <Card className="mx-auto w-full max-w-sm">
      <CardHeader>
        <CardTitle>Create an account</CardTitle>
        <CardDescription>Enter your email and choose a password</CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={onSubmit} className="flex flex-col gap-4">
          <FormField id="email" label="Email" error={errors.email?.message}>
            <Input id="email" type="email" {...register('email')} />
          </FormField>
          <FormField id="password" label="Password" error={errors.password?.message}>
            <Input id="password" type="password" {...register('password')} />
          </FormField>
          <FormField id="password_confirmation" label="Confirm password" error={errors.password_confirmation?.message}>
            <Input id="password_confirmation" type="password" {...register('password_confirmation')} />
          </FormField>
          {errors.root && (
            <p role="alert" className="text-sm text-destructive">
              {errors.root.message}
            </p>
          )}
          <Button type="submit" disabled={loading}>
            Create account
          </Button>
          <p className="text-center text-sm text-muted-foreground">
            Already have an account?{' '}
            <Link to="/login" className="underline">
              Sign in
            </Link>
          </p>
        </form>
      </CardContent>
    </Card>
  )
}
