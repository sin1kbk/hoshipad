import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import EditProfileForm from './EditProfileForm'

export const dynamic = 'force-dynamic'

export default async function EditProfilePage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    redirect('/auth/login')
  }

  return <EditProfileForm user={user} />
}
