import { useToken } from './useToken'

export const useAuthenticated = (): boolean => {
  const { token } = useToken()
  return !!token
}

export default useAuthenticated
