import React from 'react'
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import { Authenticated, Unauthenticated } from 'components'
import { Home } from './Home'
import { Login } from './Login'
import { Register } from './Register'

export const Router: React.FC = () =>
  <BrowserRouter>
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/foobar" element={<Authenticated><span>You are logged in...</span></Authenticated>} />
      <Route path="/login" element={<Unauthenticated><Login /></Unauthenticated>} />
      <Route path="/register" element={<Unauthenticated><Register /></Unauthenticated>} />
      {/* TODO add not found route/redirect */}
    </Routes>
  </BrowserRouter>

export default Router
