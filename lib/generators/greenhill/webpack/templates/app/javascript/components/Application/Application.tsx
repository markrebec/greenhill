import React from 'react'
import Router from 'routes'
import ThemeProvider from 'theme/ThemeProvider'

export const Application: React.FC = () =>
  <ThemeProvider>
    <Router />
  </ThemeProvider>

export default Application
