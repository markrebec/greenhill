import { useApolloClient } from '@apollo/client/react'
import { zodResolver } from '@hookform/resolvers/zod'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { useNavigate, useSearchParams } from 'react-router'
import { z } from 'zod'

import { ME_QUERY } from '@/graphql/queries/me'
import { api, applyApiErrors } from '@/lib/api'

const schema = z
  .object({
    password: z.string().min(6, 'Password must be at least 6 characters'),
    password_confirmation: z.string(),
  })
  .refine((data) => data.password === data.password_confirmation, {
    message: "Passwords don't match",
    path: ['password_confirmation'],
  })

type ResetPasswordValues = z.infer<typeof schema>

export function useResetPassword() {
  const client = useApolloClient()
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const [loading, setLoading] = useState(false)
  const token = searchParams.get('reset_password_token') ?? ''

  const form = useForm<ResetPasswordValues>({
    resolver: zodResolver(schema),
    defaultValues: { password: '', password_confirmation: '' },
  })

  const onSubmit = form.handleSubmit(async (values) => {
    setLoading(true)

    try {
      // Devise signs the user in on a successful reset (verified in Phase 1),
      // so refetch and go straight to the dashboard rather than /login.
      await api.put('users/password', { user: { ...values, reset_password_token: token } })
      await client.refetchQueries({ include: [ME_QUERY] })
      navigate('/dashboard', { replace: true })
    } catch (err) {
      applyApiErrors(err, form.setError, ['password', 'password_confirmation'], 'Could not reset password')
    } finally {
      setLoading(false)
    }
  })

  return { form, onSubmit, loading }
}
