import React from 'react'
import '@testing-library/jest-dom'
import { render, screen } from 'test/utils'
import { Input } from './Input'

test('renders an input with the provided type', async (): Promise<void> => {
  render(<Input type="text" data-testid="test-input" />)
  expect(screen.getByTestId('test-input').getAttribute('type')).toEqual('text')
})
