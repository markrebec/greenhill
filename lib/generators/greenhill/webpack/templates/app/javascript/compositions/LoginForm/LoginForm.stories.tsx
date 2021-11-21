import React from 'react'
import { ComponentStory, ComponentMeta } from '@storybook/react'
import { LoginForm } from './LoginForm'

export default {
  title    : 'Greenhill/LoginForm',
  component: LoginForm,
} as ComponentMeta<typeof LoginForm>

export const Example: ComponentStory<typeof LoginForm> = (props) => <LoginForm {...props} onSubmit={(e) => e.preventDefault()} />
