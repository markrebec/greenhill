import React from 'react'
import { Link } from 'react-router-dom'
import { useAuthenticated } from 'hooks'
import { Box, Text } from 'components'

export const Home: React.FC = () => {
  const user = useAuthenticated()

  return <Box>
    <Text>This is the Home page</Text>
    { !user.id && <Box>
      <Link to="/login">Login</Link> <Text>or</Text> <Link to="/register">Sign up</Link> 
    </Box> }
  </Box>
}

export default Home
