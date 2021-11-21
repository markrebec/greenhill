import { useState, useEffect } from 'react'
import axios from 'axios'
import { useAppContext } from './useAppContext'
import { useLocalStorage } from './useLocalStorage'

export type AuthUser = {
  id?: string
  email?: string
}

export const useAuthenticated = (): AuthUser => {
  const { token } = useAppContext()
  // const [ user, setUser ] = useState<AuthUser>()
  const [ user, setUser ] = useLocalStorage<AuthUser>('authUser', {})

  console.log(user)

  useEffect(() => {
    console.log(token)
    axios.post(
      '/users/sign_in',
      undefined,
      { 
        withCredentials: false,
        headers: { 
          'Authorization': token,
          'Accept': 'application/json',
        }
      }
    ).then((response) => {
      console.log(response)
      setUser({ id: response.data.id, email: response.data.email })
    }).catch((error) => {
      console.log(error)
      setUser({})
      console.log(error.response)
    })
  }, [token, setUser])

  return user
}

export default useAuthenticated