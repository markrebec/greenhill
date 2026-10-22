import { gql } from '@/graphql/generated'

export const UPDATE_PASSWORD_MUTATION = gql(`
  mutation UpdatePassword($currentPassword: String!, $password: String!, $passwordConfirmation: String!) {
    updatePassword(input: {
      currentPassword: $currentPassword
      password: $password
      passwordConfirmation: $passwordConfirmation
    }) {
      user { id }
      errors { message code path }
    }
  }
`)
