import { useApolloClient } from '@apollo/client/react'
import { zodResolver } from '@hookform/resolvers/zod'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { useLocation, useNavigate } from 'react-router'
import { z } from 'zod'

import { ME_QUERY } from '@/graphql/queries/me'
import { api, applyApiErrors } from '@/lib/api'

const schema = z.object({
  email: z.string().email('Enter a valid email address'),
  password: z.string().min(1, 'Password is required'),
})

type LoginValues = z.infer<typeof schema>

export function useLogin() {
  const client = useApolloClient()
  const navigate = useNavigate()
  const location = useLocation()
  const [loading, setLoading] = useState(false)

  const form = useForm<LoginValues>({
    resolver: zodResolver(schema),
    defaultValues: { email: '', password: '' },
  })

  const onSubmit = form.handleSubmit(async (values) => {
    setLoading(true)

    try {
      await api.post('users/sign_in', { user: values })
      await client.refetchQueries({ include: [ME_QUERY] })

      const from = (location.state as { from?: { pathname?: string } } | null)?.from?.pathname ?? '/dashboard'
      navigate(from, { replace: true })
    } catch (err) {
      applyApiErrors(err, form.setError, ['email', 'password'], 'Sign in failed')
    } finally {
      setLoading(false)
    }
  })

  return { form, onSubmit, loading }
}
