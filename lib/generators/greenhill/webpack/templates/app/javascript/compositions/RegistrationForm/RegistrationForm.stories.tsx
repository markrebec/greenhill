import React from 'react'
import { ComponentStory, ComponentMeta } from '@storybook/react'
import { RegistrationForm } from './RegistrationForm'

export default {
  title    : 'Greenhill/RegistrationForm',
  component: RegistrationForm,
} as ComponentMeta<typeof RegistrationForm>

export const Example: ComponentStory<typeof RegistrationForm> = (props) => <RegistrationForm {...props} onSubmit={(e) => e.preventDefault()} />
