import { type FormEvent, useState } from 'react'

import { api } from '@/lib/api'

type User = {
  id: number
  email: string
}

export function LoginForm() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [user, setUser] = useState<User | null>(null)
  const [error, setError] = useState<string | null>(null)

  const handleSubmit = async (event: FormEvent) => {
    event.preventDefault()
    setError(null)

    try {
      const response = await api.post<User>('users/sign_in', { user: { email, password } })
      setUser(response.data)
    } catch (err) {
      setUser(null)
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
    setUser(null)
  }

  if (user) {
    return (
      <div>
        <p>Signed in as {user.email}</p>
        <button onClick={handleSignOut}>Sign out</button>
      </div>
    )
  }

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label htmlFor="email">Email</label>
        <input id="email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
      </div>
      <div>
        <label htmlFor="password">Password</label>
        <input
          id="password"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />
      </div>
      {error && <p role="alert">{error}</p>}
      <button type="submit">Sign in</button>
    </form>
  )
}
