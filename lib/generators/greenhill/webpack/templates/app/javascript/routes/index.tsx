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
    return <Navigate to="/users/sign_in" state={{ from: location }} />
  } else {
    return <>{children}</>
  }
}

export const Router: React.FC = () =>
  <BrowserRouter>
    <Routes>
      <Route path="/" element={<RequireAuth><Home /></RequireAuth>} />
      <Route path="/users/sign_in" element={<Login />} />
      {/* TODO add not found route/redirect */}
    </Routes>
  </BrowserRouter>

export default Router
