'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import HeaderClient from '@/components/layout/HeaderClient'
import BottomNav from '@/components/layout/BottomNav'
import RecipeCard from '@/components/recipes/RecipeCard'
import { getHistoryRecipeIds, clearHistory } from '@/lib/history'
import { Recipe } from '@/types/recipe'

export default function HistoryPage() {
  const router = useRouter()
  const [recipes, setRecipes] = useState<Recipe[]>([])
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    loadHistory()
  }, [])

  const loadHistory = async () => {
    setIsLoading(true)
    try {
      const historyIds = getHistoryRecipeIds()
      if (historyIds.length === 0) {
        setRecipes([])
        setIsLoading(false)
        return
      }

      // すべてのレシピを取得して、履歴IDと一致するものをフィルタリング
      // ページサイズを大きくして全件取得
      let allRecipes: Recipe[] = []
      let page = 0
      let hasMore = true

      while (hasMore && page < 10) {
        const response = await fetch(`/api/recipes?page=${page}&pageSize=100`)
        const data = await response.json()
        allRecipes = [...allRecipes, ...(data.recipes || [])]
        hasMore = data.hasMore || false
        page++
      }

      // 履歴の順序を保持しながらフィルタリング
      const historyMap = new Map(
        historyIds.map((id, index) => [id, index])
      )
      const filteredRecipes = allRecipes
        .filter((recipe: Recipe) => historyIds.includes(recipe.id))
        .sort((a: Recipe, b: Recipe) => {
          const indexA = historyMap.get(a.id) ?? Infinity
          const indexB = historyMap.get(b.id) ?? Infinity
          return indexA - indexB
        })

      setRecipes(filteredRecipes)
    } catch (error) {
      console.error('Failed to load history:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const handleLike = async (recipeId: number) => {
    try {
      const response = await fetch(`/api/recipes/${recipeId}/like`, {
        method: 'POST',
      })
      if (!response.ok) throw new Error('Failed to toggle like')
      // レシピリストを更新
      await loadHistory()
    } catch (error) {
      console.error('Failed to toggle like:', error)
    }
  }

  const handleClearHistory = () => {
    if (confirm('閲覧履歴をすべて削除しますか？')) {
      clearHistory()
      setRecipes([])
    }
  }

  return (
    <>
      <HeaderClient initialUser={null} />
      <main className="container mx-auto px-3 py-6 pb-24 sm:px-4 md:pb-8">
        <div className="mb-6 flex items-center justify-between">
          <h1 className="text-2xl font-bold text-gray-900">最近見たレシピ</h1>
          {recipes.length > 0 && (
            <button
              onClick={handleClearHistory}
              className="text-sm text-gray-600 hover:text-gray-900"
            >
              履歴をクリア
            </button>
          )}
        </div>

        {isLoading ? (
          <div className="py-12 text-center">
            <p className="text-gray-500">読み込み中...</p>
          </div>
        ) : recipes.length === 0 ? (
          <div className="py-12 text-center">
            <p className="text-gray-500">閲覧履歴はありません</p>
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
