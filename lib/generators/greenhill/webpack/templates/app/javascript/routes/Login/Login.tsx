import React from 'react'
import { Form } from 'components'
import { LoginForm } from 'compositions'

export const Login: React.FC = () => <Form method="post" action="/users/sign_in"><LoginForm /></Form>

export default Login