import { Link } from 'react-router'

import { FormField } from '@/components/FormField'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { useLogin } from '@/hooks/useLogin'

export function Login() {
  const { form, onSubmit, loading } = useLogin()
  const {
    register,
    formState: { errors },
  } = form

  return (
    <Card className="mx-auto w-full max-w-sm">
      <CardHeader>
        <CardTitle>Sign in</CardTitle>
        <CardDescription>Enter your email and password to continue</CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={onSubmit} className="flex flex-col gap-4">
          <FormField id="email" label="Email" error={errors.email?.message}>
            <Input id="email" type="email" {...register('email')} />
          </FormField>
          <FormField id="password" label="Password" error={errors.password?.message}>
            <Input id="password" type="password" {...register('password')} />
          </FormField>
          {errors.root && (
            <p role="alert" className="text-sm text-destructive">
              {errors.root.message}
            </p>
          )}
          <Button type="submit" disabled={loading}>
            Sign in
          </Button>
          <p className="text-center text-sm text-muted-foreground">
            <Link to="/forgot-password" className="underline">
              Forgot your password?
            </Link>
          </p>
          <p className="text-center text-sm text-muted-foreground">
            <Link to="/resend-confirmation" className="underline">
              Resend confirmation email
            </Link>
          </p>
          <p className="text-center text-sm text-muted-foreground">
            Don&apos;t have an account?{' '}
            <Link to="/register" className="underline">
              Sign up
            </Link>
          </p>
        </form>
      </CardContent>
    </Card>
  )
}
