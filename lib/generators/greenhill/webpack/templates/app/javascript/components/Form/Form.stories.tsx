import React from 'react'
import { ComponentStory, ComponentMeta } from '@storybook/react'
import { Form } from './Form'

export default {
  title    : 'Greenhill/Form',
  component: Form,
} as ComponentMeta<typeof Form>

export const Basic: ComponentStory<typeof Form> = (props) => <Form {...props}>This is some text in a Form... (TODO: add some better examples, inputs/groups/etc.)</Form>
