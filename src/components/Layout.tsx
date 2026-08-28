import { Link, Outlet } from 'react-router'

import { Button } from '@/components/ui/button'
import { useCurrentUser } from '@/hooks/useCurrentUser'
import { useLogout } from '@/hooks/useLogout'

export function Layout() {
  const { user, loading } = useCurrentUser()
  const { logout } = useLogout()

  return (
    <div className="flex min-h-screen flex-col">
      <header className="flex items-center justify-between border-b px-6 py-4">
        <Link to="/" className="font-semibold">
          Meeteor
        </Link>
        <nav className="flex items-center gap-2">
          {!loading && user && (
            <>
              <Button variant="ghost" asChild>
                <Link to="/dashboard">Dashboard</Link>
              </Button>
              <Button variant="outline" onClick={logout}>
                Sign out
              </Button>
            </>
          )}
          {!loading && !user && (
            <Button asChild>
              <Link to="/login">Login</Link>
            </Button>
          )}
        </nav>
      </header>
      <main className="flex flex-1 flex-col items-center justify-center p-4">
        <Outlet />
      </main>
    </div>
  )
}
