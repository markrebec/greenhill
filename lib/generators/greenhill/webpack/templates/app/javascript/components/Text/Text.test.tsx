import React from 'react'
import '@testing-library/jest-dom'
import { render, screen } from 'test/utils'
import { Text } from './Text'

test('renders a span with the provided text', async (): Promise<void> => {
  render(<Text data-testid="test-text">Hello</Text>)
  expect(screen.getByTestId('test-text')).toHaveTextContent('Hello')
})
