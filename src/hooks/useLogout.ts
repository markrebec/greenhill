import { useApolloClient } from '@apollo/client/react'
import { useState } from 'react'
import { useNavigate } from 'react-router'

import { ME_QUERY } from '@/graphql/queries/me'
import { api } from '@/lib/api'

export function useLogout() {
  const client = useApolloClient()
  const navigate = useNavigate()
  const [loading, setLoading] = useState(false)

  const logout = async () => {
    setLoading(true)

    try {
      await api.delete('users/sign_out')
      await client.refetchQueries({ include: [ME_QUERY] })
      navigate('/', { replace: true })
    } finally {
      setLoading(false)
    }
  }

  return { logout, loading }
}
