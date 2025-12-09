'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import HeaderClient from '@/components/layout/HeaderClient'
import BottomNav from '@/components/layout/BottomNav'
import RecipeCard from '@/components/recipes/RecipeCard'
import { Recipe } from '@/types/recipe'
import { User } from '@supabase/supabase-js'
import { Edit, LogOut } from 'lucide-react'
import { signOut } from '@/app/auth/actions'

interface ProfilePageClientProps {
  user: User
  initialRecipes: Recipe[]
}

export default function ProfilePageClient({
  user,
  initialRecipes,
}: ProfilePageClientProps) {
  const router = useRouter()
  const [recipes, setRecipes] = useState<Recipe[]>(initialRecipes)

  const handleLike = async (recipeId: number) => {
    try {
      const response = await fetch(`/api/recipes/${recipeId}/like`, {
        method: 'POST',
      })
      if (!response.ok) throw new Error('Failed to toggle like')
      // レシピリストを更新
      let allRecipes: Recipe[] = []
      let page = 0
      let hasMore = true

      while (hasMore && page < 10) {
        const fetchResponse = await fetch(`/api/recipes?page=${page}&pageSize=100`)
        const data = await fetchResponse.json()
        allRecipes = [...allRecipes, ...(data.recipes || [])]
        hasMore = data.hasMore || false
        page++
      }

      const userRecipes = allRecipes.filter(
        (r: Recipe) => r.user_id === user.id
      )
      setRecipes(userRecipes)
    } catch (error) {
      console.error('Failed to toggle like:', error)
    }
  }

  const handleLogout = async () => {
    if (!confirm('ログアウトしますか？')) return
    await signOut()
  }

  return (
    <>
      <HeaderClient initialUser={null} />
      <main className="container mx-auto px-3 py-6 pb-24 sm:px-4 md:pb-8">
        {/* プロフィールカード */}
        <div className="mb-6 rounded-lg bg-white p-6 shadow-md">
          <div className="flex items-center gap-4">
            <div className="flex h-20 w-20 items-center justify-center rounded-full bg-primary-100 text-primary">
              <span className="text-2xl font-bold">
                {user.email?.charAt(0).toUpperCase() || 'U'}
              </span>
            </div>
            <div className="flex-1">
              <h2 className="text-xl font-bold text-gray-900">
                {user.email?.split('@')[0] || 'ユーザー'}
              </h2>
              <p className="text-sm text-gray-600">{user.email}</p>
            </div>
            <div className="flex gap-2">
              <button
                onClick={() => router.push('/profile/edit')}
                className="rounded-lg border border-gray-300 px-3 py-2 text-sm text-gray-700 hover:bg-gray-50"
              >
                <Edit className="h-4 w-4" />
              </button>
              <form action={handleLogout}>
                <button
                  type="submit"
                  className="rounded-lg border border-gray-300 px-3 py-2 text-sm text-gray-700 hover:bg-gray-50"
                >
                  <LogOut className="h-4 w-4" />
                </button>
              </form>
            </div>
          </div>
        </div>

        {/* マイレシピセクション */}
        <div className="mb-4 flex items-center justify-between">
          <h2 className="text-xl font-bold text-gray-900">マイレシピ</h2>
          <span className="text-sm text-gray-600">{recipes.length}件</span>
        </div>

        {/* レシピ一覧 */}
        {recipes.length === 0 ? (
          <div className="py-12 text-center">
            <p className="text-gray-500">まだレシピがありません</p>
            <button
              onClick={() => router.push('/recipes/add')}
              className="mt-4 rounded-lg bg-primary px-6 py-2 text-sm font-medium text-white hover:bg-primary/90"
            >
              レシピを追加
            </button>
          </div>
        ) : (
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
            {recipes.map((recipe) => (
              <div key={recipe.id} className="flex w-full">
                <RecipeCard recipe={recipe} onLike={handleLike} />
              </div>
            ))}
          </div>
        )}
      </main>
      <BottomNav />
    </>
  )
}
