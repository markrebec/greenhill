import React from 'react'
import { ComponentStory, ComponentMeta } from '@storybook/react'

import { Input, Checkbox } from './Input'

// More on default export: https://storybook.js.org/docs/react/writing-stories/introduction#default-export
export default {
  title: 'Greenhill/Input',
  component: Input,
  // More on argTypes: https://storybook.js.org/docs/react/api/argtypes
  // argTypes: {
  //   backgroundColor: { control: 'color' },
  // },
} as ComponentMeta<typeof Input>

// More on component templates: https://storybook.js.org/docs/react/writing-stories/introduction#using-args
const Template: ComponentStory<typeof Input> = (args) => <Input {...args} />

export const TextInput = Template.bind({})
// More on args: https://storybook.js.org/docs/react/writing-stories/args
TextInput.args = {
  type: 'text'
}

// TODO sort out the rest of these input examples

export const CheckboxInput: ComponentStory<typeof Checkbox> = (props) => <Checkbox {...props} />

export const RadioInput = Template.bind({})
RadioInput.args = {
  type: 'radio'
}
