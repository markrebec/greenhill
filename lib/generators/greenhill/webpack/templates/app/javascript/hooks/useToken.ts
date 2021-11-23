import { useEffect } from 'react'
import { useAppContext } from './useAppContext'

const parseToken = (token: string) => {
  const base64Url = token.split('.')[1];
  const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
  const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
      return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
  }).join(''));

  return JSON.parse(jsonPayload);
}

const valid = (token: string | undefined): boolean => {
  if (!token) return false
  const parsed = parseToken(token)
  return parsed.exp && parsed.exp > Math.round(Date.now() / 1000)
}

export const useToken = (): { token?: string, setToken?: (t?: string) => void } | undefined => {
  const { token, setToken } = useAppContext()
  const tokenValid = valid(token)

  useEffect(() => {
    if (!tokenValid) setToken(undefined)
  }, [tokenValid, setToken])

  return {
    token: tokenValid ? token : undefined,
    setToken
  }
}

export default useToken