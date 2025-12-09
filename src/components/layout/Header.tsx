export const revalidate = 0;
export const dynamic = 'force-dynamic';

import { createClient } from '@/lib/supabase/server'
import HeaderClient from './HeaderClient'

export default async function Header() {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  return <HeaderClient initialUser={user} />
}
