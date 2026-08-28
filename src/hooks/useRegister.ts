import { useApolloClient } from '@apollo/client/react'
import { zodResolver } from '@hookform/resolvers/zod'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { useLocation, useNavigate } from 'react-router'
import { z } from 'zod'

import { ME_QUERY } from '@/graphql/queries/me'
import { api, applyApiErrors } from '@/lib/api'

const schema = z
  .object({
    email: z.string().email('Enter a valid email address'),
    password: z.string().min(6, 'Password must be at least 6 characters'),
    password_confirmation: z.string(),
  })
  .refine((data) => data.password === data.password_confirmation, {
    message: "Passwords don't match",
    path: ['password_confirmation'],
  })

type RegisterValues = z.infer<typeof schema>

export function useRegister() {
  const client = useApolloClient()
  const navigate = useNavigate()
  const location = useLocation()
  const [loading, setLoading] = useState(false)

  const form = useForm<RegisterValues>({
    resolver: zodResolver(schema),
    defaultValues: { email: '', password: '', password_confirmation: '' },
  })

  const onSubmit = form.handleSubmit(async (values) => {
    setLoading(true)

    try {
      // Devise auto-signs-in on successful registration (verified in Phase 1).
      await api.post('users', { user: values })
      await client.refetchQueries({ include: [ME_QUERY] })

      const from = (location.state as { from?: { pathname?: string } } | null)?.from?.pathname ?? '/dashboard'
      navigate(from, { replace: true })
    } catch (err) {
      applyApiErrors(err, form.setError, ['email', 'password', 'password_confirmation'], 'Registration failed')
    } finally {
      setLoading(false)
    }
  })

  return { form, onSubmit, loading }
}
