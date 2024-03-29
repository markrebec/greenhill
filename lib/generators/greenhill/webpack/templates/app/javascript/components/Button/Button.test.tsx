import React from 'react'
import '@testing-library/jest-dom'
import { render, screen } from 'test/utils'
import { Button } from './Button'

test('renders a button with the provided text', async (): Promise<void> => {
  render(<Button>Hello</Button>)
  expect(screen.getByRole('button')).toHaveTextContent('Hello')
})
