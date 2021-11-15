import React from 'react'
import '@testing-library/jest-dom'
import { render, screen } from 'test/utils'
import { Form } from './Form'

test('renders a div with the provided children', async (): Promise<void> => {
  render(<Form data-testid="test-form">Hello</Form>)
  expect(screen.getByTestId('test-form')).toHaveTextContent('Hello')
})
