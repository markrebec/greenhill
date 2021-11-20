import React from 'react'
import {
  BrowserRouter,
  Routes,
  Route,
  Navigate,
  useLocation
} from 'react-router-dom'
import { useAppContext } from 'hooks'
import { Home } from './Home'
import { Login } from './Login'

const RequireAuth: React.FC = ({ children }) => {
  const { token } = useAppContext()
  const location = useLocation()

  if (!token) {
    return <Navigate to="/login" state={{ from: location }} />
  } else {
    return <>{children}</>
  }
}

export const Router: React.FC = () =>
  <BrowserRouter>
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/foobar" element={<RequireAuth><span>You are logged in...</span></RequireAuth>} />
      <Route path="/login" element={<Login />} />
      {/* TODO add not found route/redirect */}
    </Routes>
  </BrowserRouter>

export default Router
