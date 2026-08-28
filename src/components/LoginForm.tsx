import { useQuery } from '@apollo/client/react'
import { type FormEvent, useState } from 'react'

import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { ME_QUERY } from '@/graphql/queries/me'
import { api } from '@/lib/api'

export function LoginForm() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const { data, loading, refetch } = useQuery(ME_QUERY)
  const user = data?.me

  const handleSubmit = async (event: FormEvent) => {
    event.preventDefault()
    setError(null)

    try {
      await api.post('users/sign_in', { user: { email, password } })
      await refetch()
    } catch (err) {
      if (err && typeof err === 'object' && 'response' in err) {
        const response = (err as { response?: { data?: { error?: string } } }).response
        setError(response?.data?.error ?? 'Sign in failed')
      } else {
        setError('Sign in failed')
      }
    }
  }

  const handleSignOut = async () => {
    await api.delete('users/sign_out')
    await refetch()
  }

  if (loading) {
    return (
      <Card className="mx-auto w-full max-w-sm">
        <CardContent>
          <p className="text-sm text-muted-foreground">Loading…</p>
        </CardContent>
      </Card>
    )
  }

  if (user) {
    return (
      <Card className="mx-auto w-full max-w-sm">
        <CardHeader>
          <CardTitle>Signed in</CardTitle>
          <CardDescription>{user.email}</CardDescription>
        </CardHeader>
        <CardContent>
          <Button variant="outline" onClick={handleSignOut}>
            Sign out
          </Button>
        </CardContent>
      </Card>
    )
  }

  return (
    <Card className="mx-auto w-full max-w-sm">
      <CardHeader>
        <CardTitle>Sign in</CardTitle>
        <CardDescription>Enter your email and password to continue</CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="flex flex-col gap-4">
          <div className="flex flex-col gap-2">
            <Label htmlFor="email">Email</Label>
            <Input id="email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
          </div>
          <div className="flex flex-col gap-2">
            <Label htmlFor="password">Password</Label>
            <Input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>
          {error && (
            <p role="alert" className="text-sm text-destructive">
              {error}
            </p>
          )}
          <Button type="submit">Sign in</Button>
        </form>
      </CardContent>
    </Card>
  )
}
