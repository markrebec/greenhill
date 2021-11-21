import React, { FormEvent } from 'react'
import { Text, Form, Fieldset, Field, Button } from 'components'

export type RegistrationFormProps = {
  error?: string
  onSubmit?: (e: FormEvent) => void
  onEmailChange?: (email: string) => void
  onPasswordChange?: (password: string) => void
  onPasswordConfirmationChange?: (password: string) => void
}

export const RegistrationForm: React.FC<RegistrationFormProps> = ({ error, onSubmit, onEmailChange, onPasswordChange, onPasswordConfirmationChange }) => {
  return <Form onSubmit={onSubmit} display="flex" flexDirection="column" justifyContent="space-between" maxWidth={[0]} mx="auto">
    {error && <Text color="negative">{error}</Text>}

    <Field label="Email" type="text" name="user[email]" autoFocus onChange={e => { if (onEmailChange) onEmailChange(e.target.value) }} />

    <Field label="Password" type="password" name="user[password]" onChange={e => { if (onPasswordChange) onPasswordChange(e.target.value) }}/>

    <Field label="Confirm Password" type="password" name="user[password_confirmation]" onChange={e => { if (onPasswordConfirmationChange) onPasswordConfirmationChange(e.target.value) }}/>

    <Fieldset display="flex" flexDirection="row" justifyContent="flex-end">
      <Button type="submit" variant="primary">Sign up</Button>
    </Fieldset>
  </Form>
}

export default RegistrationForm
