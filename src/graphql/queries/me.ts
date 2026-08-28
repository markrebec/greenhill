import { gql } from '@/graphql/generated'

export const ME_QUERY = gql(`
  query Me {
    me {
      id
      email
    }
  }
`)
