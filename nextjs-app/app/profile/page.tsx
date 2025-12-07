import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { getUserRecipes } from '@/lib/api/recipes'
import ProfilePageClient from './ProfilePageClient'

export const dynamic = 'force-dynamic'

export default async function ProfilePage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    redirect('/auth/login')
  }

  const recipes = await getUserRecipes(user.id)

  return <ProfilePageClient user={user} initialRecipes={recipes} />
}
