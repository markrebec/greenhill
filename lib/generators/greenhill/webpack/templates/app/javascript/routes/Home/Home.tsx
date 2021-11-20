import React from 'react'
import axios from 'axios'
import { Link } from 'react-router-dom'
import { useAppContext } from 'hooks'
import { Box, Text } from 'components'

export const useTestAuth = () => {
  const { token } = useAppContext()
  fetch('/', {
    credentials: 'omit',
    headers: { 'Authorization': token }
  })
  axios.get('/', {
    withCredentials: false,
    headers: { 'Authorization': token }
  })
}

export const Home: React.FC = () => {
  useTestAuth()

  return <Box>
    <Text>This is the Home page</Text>
    <Link to="/login">Login</Link>
  </Box>
}

export default Home