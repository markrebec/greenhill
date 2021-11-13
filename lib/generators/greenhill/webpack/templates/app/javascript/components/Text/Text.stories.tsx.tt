import React from 'react'
import { ComponentStory, ComponentMeta } from '@storybook/react'
import { Text } from './Text'

export default {
  title    : 'Greenhill/Text',
  component: Text,
} as ComponentMeta<typeof Text>

export const Span: ComponentStory<typeof Text> = (props) => <Text {...props}>This is some text in a span...</Text>

export const Paragraph: ComponentStory<typeof Text> = (props) => <Text as="p" {...props}>This is some text in a paragraph...</Text>

export const ListItem: ComponentStory<typeof Text> = (props) => <ul>
  <Text as="li" {...props}>This is some text in a list item...</Text>
  <Text as="li" {...props}>This is another list item...</Text>
</ul>
