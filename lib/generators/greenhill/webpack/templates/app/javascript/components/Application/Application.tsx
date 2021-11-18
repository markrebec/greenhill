import React, { createContext } from 'react'
import Router from 'routes'
import { useLocalStorage } from 'hooks'
import ThemeProvider from 'theme/ThemeProvider'

export type AppContext = {
  token?: string
  setToken?: (token?: string) => void
}

export const ApplicationContext = createContext<AppContext>({})

const ContextProvider: React.FC = ({ children }) => {
  const [state, setState] = useLocalStorage<AppContext>('appContext', {})

  return <ApplicationContext.Provider value={{ token: state.token, setToken: (token) => setState({ ...state, token }) }}>
    {children}
  </ApplicationContext.Provider>
}

export const Application: React.FC = () =>
  <ContextProvider>
    <ThemeProvider>
      <Router />
    </ThemeProvider>
  </ContextProvider>

export default Application
