import { Link } from 'react-router'

import { Button } from '@/components/ui/button'
import { useCurrentUser } from '@/hooks/useCurrentUser'

export function Home() {
  const { user } = useCurrentUser()

  return (
    <div className="flex max-w-sm flex-col items-center gap-4 text-center">
      <h1 className="text-2xl font-semibold">Greenhill</h1>
      <p className="text-muted-foreground">Welcome to Greenhill.</p>
      <Button asChild>
        <Link to={user ? '/dashboard' : '/register'}>{user ? 'Go to dashboard' : 'Get started'}</Link>
      </Button>
    </div>
  )
}
