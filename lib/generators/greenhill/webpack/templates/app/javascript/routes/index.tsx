import React from 'react'
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import { Home } from './Home'
import { Login } from './Login'

export const Router: React.FC = () =>
  <BrowserRouter>
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/users/sign_in" element={<Login />} />
      {/* TODO add not found route/redirect */}
    </Routes>
  </BrowserRouter>

export default Router
