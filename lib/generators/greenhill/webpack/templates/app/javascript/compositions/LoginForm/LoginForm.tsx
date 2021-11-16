import React from 'react'
import { Box, Text, Fieldset, Input, Label, Field, Button } from 'components'

export const LoginForm: React.FC = () =>
  <Box display="flex" flexDirection="column" justifyContent="space-between" maxWidth={[0]} mx="auto">
    <Field label="Email" type="text" name="email" />

    <Field label="Password" type="password" name="password" />

    <Fieldset mb={[2, 4]}>
      <Label>
        <Input type="checkbox" name="remember" />
        <Text>Remember me</Text>
      </Label>
    </Fieldset>

    <Fieldset display="flex" flexDirection="row" justifyContent="flex-end">
      <Button type="submit" variant="primary">Login</Button>
    </Fieldset>
  </Box>

export default LoginForm
