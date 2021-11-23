import React from 'react'
import { Navigate, useLocation } from 'react-router-dom'
import { useAuthenticated } from 'hooks'


export const Authenticated: React.FC = ({ children }) => {
  const auth = useAuthenticated()
  const location = useLocation()

  if (!auth) {
    // "you must login to continue"
    return <Navigate to="/login" state={{ from: location }} />
  } else {
    return <>{children}</>
  }
}

export const Unauthenticated: React.FC = ({ children }) => {
  const auth = useAuthenticated()

  if (auth) {
    // "you are already logged in"
    return <Navigate to="/" />
  } else {
    return <>{children}</>
  }
}

export default Authenticated