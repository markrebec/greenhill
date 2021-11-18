import { useContext } from 'react'
import { ApplicationContext } from 'components/Application'

export const useAppContext = () => {
  const appContext = useContext(ApplicationContext)
  return appContext
}

export default useAppContext