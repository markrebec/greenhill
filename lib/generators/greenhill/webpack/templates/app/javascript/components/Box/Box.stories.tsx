import React from 'react'
import { ComponentStory, ComponentMeta } from '@storybook/react'
import { Box } from './Box'

export default {
  title    : 'Greenhill/Box',
  component: Box,
} as ComponentMeta<typeof Box>

export const Basic: ComponentStory<typeof Box> = (props) => <Box {...props}>This is some text in a Box... (TODO: add some better examples, flexbox/etc.)</Box>
