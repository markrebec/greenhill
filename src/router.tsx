import { createBrowserRouter } from 'react-router'

import { Authenticated, Unauthenticated } from '@/components/auth/Authenticated'
import { Layout } from '@/components/Layout'
import { Dashboard } from '@/pages/Dashboard'
import { ForgotPassword } from '@/pages/ForgotPassword'
import { Home } from '@/pages/Home'
import { Login } from '@/pages/Login'
import { NotFound } from '@/pages/NotFound'
import { Register } from '@/pages/Register'
import { ResetPassword } from '@/pages/ResetPassword'

export const router = createBrowserRouter([
  {
    element: <Layout />,
    children: [
      { path: '/', element: <Home /> },
      {
        path: '/login',
        element: (
          <Unauthenticated>
            <Login />
          </Unauthenticated>
        ),
      },
      {
        path: '/register',
        element: (
          <Unauthenticated>
            <Register />
          </Unauthenticated>
        ),
      },
      {
        path: '/forgot-password',
        element: (
          <Unauthenticated>
            <ForgotPassword />
          </Unauthenticated>
        ),
      },
      {
        path: '/reset-password',
        element: (
          <Unauthenticated>
            <ResetPassword />
          </Unauthenticated>
        ),
      },
      {
        path: '/dashboard',
        element: (
          <Authenticated>
            <Dashboard />
          </Authenticated>
        ),
      },
      { path: '*', element: <NotFound /> },
    ],
  },
])
