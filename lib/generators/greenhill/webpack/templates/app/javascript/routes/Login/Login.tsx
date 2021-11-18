import React, { useState, useContext } from 'react'
import { useNavigate, useLocation } from 'react-router'
import axios from 'axios'
import { ApplicationContext } from 'components/Application'
import { LoginForm } from 'compositions/LoginForm'

export type LoginFormState = {
  email?: string
  password?: string
  rememberMe?: boolean
}

export const Login: React.FC = () => {
  const [ state, setState ] = useState<LoginFormState>({ email: undefined, password: undefined, rememberMe: false })
  const [ error, setError ] = useState<string>()
  const { setToken } = useContext(ApplicationContext)
  const navigate = useNavigate()
  const location = useLocation()
  const from = location.state?.from?.pathname || "/"

  // TODO create default axios client for re-use
  const submitLogin = (): void => {
    axios.post(
      '/users/sign_in',
      { user: state },
      { headers: { 'Accept': 'application/json' } }
    ).then((response) => {
      setToken(response.headers['authorization'])
      navigate(from, { replace: true })
    }).catch((error) => {
      if (error.response.data) {
        setError(error.response.data.error)
      } else {
        setError(error)
      }
    })
  }

  return <LoginForm
    error={error}
    onEmailChange={email => setState({ ...state, email })}
    onPasswordChange={password => setState({ ...state, password })}
    onRememberMeChange={rememberMe => setState({ ...state, rememberMe })}
    onSubmit={submitLogin} />
}

export default Login