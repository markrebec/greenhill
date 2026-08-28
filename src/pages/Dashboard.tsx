import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { useCurrentUser } from '@/hooks/useCurrentUser'

export function Dashboard() {
  const { user } = useCurrentUser()

  return (
    <Card className="mx-auto w-full max-w-sm">
      <CardHeader>
        <CardTitle>Dashboard</CardTitle>
        <CardDescription>Welcome back{user ? `, ${user.email}` : ''}.</CardDescription>
      </CardHeader>
      <CardContent>
        <p className="text-sm text-muted-foreground">You&apos;re signed in.</p>
      </CardContent>
    </Card>
  )
}
