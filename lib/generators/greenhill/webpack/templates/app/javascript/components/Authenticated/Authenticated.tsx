/* eslint-disable react/no-unescaped-entities */
import React from 'react'
import { Link, Navigate, useLocation } from 'react-router-dom'
import { useAuthenticated } from 'hooks'
import { Box, Text } from 'components'


export const Authenticated: React.FC<{ redirect?: boolean }> = ({ redirect=true, children }) => {
  const auth = useAuthenticated()
  const location = useLocation()

  if (!auth) {
    return redirect ? <Navigate to="/login" state={{ from: location }} /> : <Box maxWidth={[1]} mx="auto">
      <Text as="h2">You must login to continue</Text>
      <Text as="p"><Link to="/login" state={{ from: location }}>Click here to login</Link>, or if you don't have an account, <Link to="/register">click here to sign up</Link></Text>
    </Box>
  } else {
    return <>{children}</>
  }
}

export const Unauthenticated: React.FC<{ redirect?: boolean }> = ({ redirect=true, children }) => {
  const auth = useAuthenticated()
  const location = useLocation()

  if (auth) {
    return redirect ? <Navigate to="/" /> : <Box maxWidth={[1]} mx="auto">
      <Text as="h2">You are already logged in</Text>
      <Text as="p"><Link to="/logout" state={{ from: location }}>Click here to logout</Link>, or <Link to="/">click here return home</Link></Text>
    </Box>
  } else {
    return <>{children}</>
  }
}

export default Authenticated
