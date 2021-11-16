import React from 'react'
import { Form, Fieldset, Input, Label, Button } from 'components'

export const LoginForm: React.FC = () => <Form method="post" action="/users/sign_in">
  <Fieldset>
    <Label>Email</Label>
    <Input type="text" name="email" placeholder="email" />
  </Fieldset>

  <Fieldset>
    <Label>Password</Label>
    <Input type="password" name="password" placeholder="password" />
  </Fieldset>

  <Button type="submit" variant="primary">Login</Button>
</Form>

export default LoginForm