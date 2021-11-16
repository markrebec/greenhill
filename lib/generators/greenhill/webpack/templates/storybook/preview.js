import React from 'react'
import { ThemeProvider } from '../app/javascript/theme/ThemeProvider'

export const decorators = [
  (Story) => (
    <ThemeProvider>
      <Story />
    </ThemeProvider>
  ),
]

export const parameters = {
  argTypes: {
    theme: {
      control: { type: null },
      // table: { disable: true },
    },
    as: {
      control: { type: null },
      // table: { disable: true },
    },
    forwardedAs: {
      control: { type: null },
      // table: { disable: true },
    },
  },
  actions: { argTypesRegex: "^on[A-Z].*" },
  controls: {
    matchers: {
      color: /(background|color)$/i,
      date: /Date$/,
    },
  },
}
