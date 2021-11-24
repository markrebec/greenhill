import { useContext } from 'react'
import { ApplicationContext, AppContext } from 'components/Application'

export const useAppContext = (): AppContext => {
  const appContext = useContext<AppContext>(ApplicationContext)
  return appContext
}

export default useAppContext
