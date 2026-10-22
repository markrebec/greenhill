import { MockedProvider } from '@apollo/client/testing/react'
import { act, renderHook, waitFor } from '@testing-library/react'
import { describe, expect, it } from 'bun:test'

import { UPDATE_PASSWORD_MUTATION } from '@/graphql/mutations/updatePassword'

import { useUpdatePassword } from './useUpdatePassword'

const variables = {
  currentPassword: 'password123',
  password: 'newpassword123',
  passwordConfirmation: 'newpassword123',
}

function renderWithMocks(mocks: ConstructorParameters<typeof MockedProvider>[0]['mocks']) {
  return renderHook(
    () => {
      const hook = useUpdatePassword()
      // A real form component reads formState.errors in its own render to
      // display them, which is what activates react-hook-form's Proxy-based
      // subscription for re-renders. Mirror that here, or errors set via
      // setError() never show up in a later `result.current` read.
      void hook.form.formState.errors
      return hook
    },
    { wrapper: ({ children }) => <MockedProvider mocks={mocks}>{children}</MockedProvider> },
  )
}

async function submit(result: ReturnType<typeof renderWithMocks>['result']) {
  result.current.form.setValue('currentPassword', variables.currentPassword)
  result.current.form.setValue('password', variables.password)
  result.current.form.setValue('passwordConfirmation', variables.passwordConfirmation)

  await act(async () => {
    await result.current.onSubmit()
  })
}

describe('useUpdatePassword', () => {
  it('succeeds and resets the form when the mutation returns no errors', async () => {
    const { result } = renderWithMocks([
      {
        request: { query: UPDATE_PASSWORD_MUTATION, variables },
        result: { data: { updatePassword: { user: { id: '1' }, errors: [] } } },
      },
    ])

    await submit(result)

    await waitFor(() => expect(result.current.succeeded).toBe(true))
    expect(result.current.form.getValues('currentPassword')).toBe('')
  })

  it('applies a mutation-level error to the matching form field', async () => {
    const { result } = renderWithMocks([
      {
        request: { query: UPDATE_PASSWORD_MUTATION, variables },
        result: {
          data: {
            updatePassword: {
              user: null,
              errors: [{ message: 'Current password is invalid', code: 'invalid', path: ['currentPassword'] }],
            },
          },
        },
      },
    ])

    await submit(result)

    await waitFor(() => {
      expect(result.current.form.formState.errors.currentPassword?.message).toBe('Current password is invalid')
    })
    expect(result.current.succeeded).toBe(false)
  })

  it('applies a top-level GraphQL error (e.g. a Pundit denial surfaced via rescue_from)', async () => {
    const { result } = renderWithMocks([
      {
        request: { query: UPDATE_PASSWORD_MUTATION, variables },
        result: { errors: [{ message: 'You are not authorized to perform this action.' }] },
      },
    ])

    await submit(result)

    await waitFor(() => {
      expect(result.current.form.formState.errors.root?.message).toBe('You are not authorized to perform this action.')
    })
    expect(result.current.succeeded).toBe(false)
  })

  it('handles a network-level error without crashing', async () => {
    const { result } = renderWithMocks([
      {
        request: { query: UPDATE_PASSWORD_MUTATION, variables },
        error: new Error('Failed to fetch'),
      },
    ])

    await submit(result)

    await waitFor(() => {
      expect(result.current.form.formState.errors.root?.message).toBe('Failed to fetch')
    })
    expect(result.current.succeeded).toBe(false)
    expect(result.current.loading).toBe(false)
  })
})
