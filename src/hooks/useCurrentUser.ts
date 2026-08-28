import { useQuery } from '@apollo/client/react'

import { ME_QUERY } from '@/graphql/queries/me'

export function useCurrentUser() {
  const { data, loading, refetch } = useQuery(ME_QUERY)

  return { user: data?.me ?? null, loading, refetch }
}
