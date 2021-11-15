import React, { FC, ReactElement } from 'react'
import { render, RenderOptions } from '@testing-library/react'
import { ThemeProvider } from 'theme/ThemeProvider'

// TODO add various providers, etc. here that are required for rendering components
const TestProviders: FC = ({children}) => {
  return <ThemeProvider>{children}</ThemeProvider>
}

const customRender = (
  ui: ReactElement,
  options?: Omit<RenderOptions, 'wrapper'>,
) => render(ui, {wrapper: TestProviders, ...options})

export * from '@testing-library/react'
export {customRender as render}