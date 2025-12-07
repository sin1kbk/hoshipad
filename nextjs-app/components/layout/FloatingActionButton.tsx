'use client'

import Link from 'next/link'
import { Plus } from 'lucide-react'
import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'

export default function FloatingActionButton() {
  const [isAuthenticated, setIsAuthenticated] = useState(false)

  useEffect(() => {
    const supabase = createClient()

    supabase.auth.getUser().then(({ data: { user } }) => {
      setIsAuthenticated(!!user)
    })

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setIsAuthenticated(!!session?.user)
    })

    return () => subscription.unsubscribe()
  }, [])

  const handleClick = (e: React.MouseEvent) => {
    if (!isAuthenticated) {
      e.preventDefault()
      alert('レシピを追加するにはログインが必要です')
      window.location.href = '/auth/login'
    }
  }

  return (
    <Link
      href="/recipes/add"
      onClick={handleClick}
      className="fixed bottom-20 right-6 md:bottom-8 z-40 h-14 w-14 rounded-full bg-gradient-to-br from-primary to-orange-500 shadow-2xl hover:shadow-primary/50 flex items-center justify-center transition-all hover:scale-110 active:scale-95"
      title="レシピを追加"
    >
      <Plus className="h-7 w-7 text-white" />
    </Link>
  )
}
