import React from 'react'
import '@testing-library/jest-dom'
import { render, screen } from 'test/utils'
import { Box } from './Box'

test('renders a div with the provided children', async (): Promise<void> => {
  render(<Box data-testid="test-box">Hello</Box>)
  expect(screen.getByTestId('test-box')).toHaveTextContent('Hello')
})
