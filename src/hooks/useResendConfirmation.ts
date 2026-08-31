import { zodResolver } from '@hookform/resolvers/zod'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { z } from 'zod'

import { api, applyApiErrors } from '@/lib/api'

const schema = z.object({
  email: z.string().email('Enter a valid email address'),
})

type ResendConfirmationValues = z.infer<typeof schema>

export function useResendConfirmation() {
  const [loading, setLoading] = useState(false)
  const [submitted, setSubmitted] = useState(false)

  const form = useForm<ResendConfirmationValues>({
    resolver: zodResolver(schema),
    defaultValues: { email: '' },
  })

  const onSubmit = form.handleSubmit(async (values) => {
    setLoading(true)

    try {
      await api.post('users/confirmation', { user: values })
      setSubmitted(true)
    } catch (err) {
      applyApiErrors(err, form.setError, ['email'], 'Could not send confirmation instructions')
    } finally {
      setLoading(false)
    }
  })

  return { form, onSubmit, loading, submitted }
}
