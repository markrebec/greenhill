import { FormField } from '@/components/FormField'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { useResetPassword } from '@/hooks/useResetPassword'

export function ResetPassword() {
  const { form, onSubmit, loading } = useResetPassword()
  const {
    register,
    formState: { errors },
  } = form

  return (
    <Card className="mx-auto w-full max-w-sm">
      <CardHeader>
        <CardTitle>Reset your password</CardTitle>
        <CardDescription>Enter a new password below</CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={onSubmit} className="flex flex-col gap-4">
          <FormField id="password" label="New password" error={errors.password?.message}>
            <Input id="password" type="password" {...register('password')} />
          </FormField>
          <FormField
            id="password_confirmation"
            label="Confirm new password"
            error={errors.password_confirmation?.message}>
            <Input id="password_confirmation" type="password" {...register('password_confirmation')} />
          </FormField>
          {errors.root && (
            <p role="alert" className="text-sm text-destructive">
              {errors.root.message}
            </p>
          )}
          <Button type="submit" disabled={loading}>
            Reset password
          </Button>
        </form>
      </CardContent>
    </Card>
  )
}
