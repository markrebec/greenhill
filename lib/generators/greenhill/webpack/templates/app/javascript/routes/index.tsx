import React from 'react'
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import { Authenticated } from 'components'
import { Home } from './Home'
import { Login } from './Login'
import { Register } from './Register'

export const Router: React.FC = () =>
  <BrowserRouter>
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/foobar" element={<Authenticated><span>You are logged in...</span></Authenticated>} />
      <Route path="/login" element={<Login />} />
      <Route path="/register" element={<Register />} />
      {/* TODO add not found route/redirect */}
    </Routes>
  </BrowserRouter>

export default Router
