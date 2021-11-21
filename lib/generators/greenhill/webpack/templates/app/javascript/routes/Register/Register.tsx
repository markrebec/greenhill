import React, { FormEvent, useState } from 'react'
import { useNavigate, useLocation } from 'react-router'
import axios from 'axios'
import { useAppContext } from 'hooks'
import { RegistrationForm } from 'compositions/RegistrationForm'

export type RegistrationFormState = {
  email: string
  password: string
  password_confirmation: string
}

export const Register: React.FC = () => {
  const [ state, setState ] = useState<RegistrationFormState>({ email: '', password: '', password_confirmation: '' })
  const [ error, setError ] = useState<string>()
  const { setToken } = useAppContext()
  const navigate = useNavigate()
  const location = useLocation()
  const from = location.state?.from?.pathname || "/"

  // TODO create default axios client for re-use
  const submitRegistration = (e: FormEvent): void => {
    e.preventDefault()
    axios.post(
      '/users',
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

  return <RegistrationForm
    error={error}
    onEmailChange={email => setState({ ...state, email })}
    onPasswordChange={password => setState({ ...state, password })}
    onPasswordConfirmationChange={password => setState({ ...state, password_confirmation: password })}
    onSubmit={submitRegistration} />
}

export default Register
