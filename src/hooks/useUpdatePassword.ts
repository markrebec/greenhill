import { useMutation } from '@apollo/client/react'
import { zodResolver } from '@hookform/resolvers/zod'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { z } from 'zod'

import { UPDATE_PASSWORD_MUTATION } from '@/graphql/mutations/updatePassword'
import { applyMutationErrors } from '@/lib/graphql'

const schema = z
  .object({
    currentPassword: z.string().min(1, 'Current password is required'),
    password: z.string().min(6, 'Password must be at least 6 characters'),
    passwordConfirmation: z.string().min(1, 'Please confirm your new password'),
  })
  .refine((data) => data.password === data.passwordConfirmation, {
    message: 'Passwords do not match',
    path: ['passwordConfirmation'],
  })

type UpdatePasswordValues = z.infer<typeof schema>

const knownFields = ['currentPassword', 'password', 'passwordConfirmation'] as const

export function useUpdatePassword() {
  const [mutate] = useMutation(UPDATE_PASSWORD_MUTATION, { errorPolicy: 'all' })
  const [loading, setLoading] = useState(false)
  const [succeeded, setSucceeded] = useState(false)

  const form = useForm<UpdatePasswordValues>({
    resolver: zodResolver(schema),
    defaultValues: { currentPassword: '', password: '', passwordConfirmation: '' },
  })

  const onSubmit = form.handleSubmit(async (values) => {
    setLoading(true)
    setSucceeded(false)

    try {
      const { data, error } = await mutate({ variables: values })
      const mutationErrors = data?.updatePassword?.errors

      if (error || (mutationErrors && mutationErrors.length > 0)) {
        applyMutationErrors(error, mutationErrors, form.setError, knownFields)
        return
      }

      setSucceeded(true)
      form.reset()
    } finally {
      setLoading(false)
    }
  })

  return { form, onSubmit, loading, succeeded }
}
