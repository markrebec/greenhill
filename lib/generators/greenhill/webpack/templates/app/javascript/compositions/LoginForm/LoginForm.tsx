import React, { FormEvent } from 'react'
import { Text, Form, Fieldset, Input, Label, Field, Button } from 'components'

export type LoginFormProps = {
  error?: string
  onSubmit?: (e: FormEvent) => void
  onEmailChange?: (email: string) => void
  onPasswordChange?: (password: string) => void
  onRememberMeChange?: (remember: boolean) => void
}

export const LoginForm: React.FC<LoginFormProps> = ({ error, onSubmit, onEmailChange, onPasswordChange, onRememberMeChange }) => {
  return <Form onSubmit={onSubmit} display="flex" flexDirection="column" justifyContent="space-between" maxWidth={[0]} mx="auto">
    {error && <Text color="negative">{error}</Text>}

    <Field label="Email" type="text" name="user[email]" autoFocus onChange={e => { if (onEmailChange) onEmailChange(e.target.value) }} />

    <Field label="Password" type="password" name="user[password]" onChange={e => { if (onPasswordChange) onPasswordChange(e.target.value) }}/>

    <Fieldset mb={[2, 4]}>
      <Label>
        <Input type="checkbox" name="user[remember_me]" onChange={e => { if (onRememberMeChange) onRememberMeChange(e.target.checked) }} />
        <Text>Remember me</Text>
      </Label>
    </Fieldset>

    <Fieldset display="flex" flexDirection="row" justifyContent="flex-end">
      <Button type="submit" variant="primary">Login</Button>
    </Fieldset>
  </Form>
}

export default LoginForm
