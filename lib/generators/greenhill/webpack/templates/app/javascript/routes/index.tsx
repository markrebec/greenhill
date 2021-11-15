import React from 'react'
import { BrowserRouter, Routes, Route } from 'react-router-dom'

import Text from 'components/Text'
const Home: React.FC = () => <Text>This is the Home page</Text>

export const Router: React.FC = () => <BrowserRouter>
  <Routes>
    <Route path="/" element={<Home />} />
  </Routes>
</BrowserRouter>

export default Router