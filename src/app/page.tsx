import { getAllRecipes, searchRecipes } from '@/lib/api/recipes'
import RecipeList from '@/components/recipes/RecipeList'
import RecipeFilters from '@/components/recipes/RecipeFilters'
import CategoryFilter from '@/components/recipes/CategoryFilter'
import Header from '@/components/layout/Header'
import BottomNav from '@/components/layout/BottomNav'
import FloatingActionButton from '@/components/layout/FloatingActionButton'
import { RecipeSource } from '@/types/recipe'

export const dynamic = 'force-dynamic'

interface HomePageProps {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>
}

export default async function HomePage({ searchParams }: HomePageProps) {
  const params = await searchParams
  const query = typeof params.q === 'string' ? params.q : undefined
  const source = typeof params.source === 'string' ? params.source as RecipeSource : undefined
  const tag = typeof params.tag === 'string' ? params.tag : undefined

  const result = query || source || tag
    ? await searchRecipes({ query, source, tag, page: 0, pageSize: 12 })
    : await getAllRecipes(0, 12)

  const initialRecipes = result.recipes

  async function handleLike(recipeId: number) {
    'use server'
    const { toggleLike } = await import('@/lib/api/recipes')
    await toggleLike(recipeId)
  }

  return (
    <>
      <Header />
      <main className="container mx-auto px-3 py-6 pb-24 sm:px-4 md:pb-8">
        {/* カテゴリーフィルター */}
        <CategoryFilter />

        {/* セクションタイトル */}
        <div className="mb-4">
          <h2 className="text-xl font-bold text-gray-900">保存されたレシピ</h2>
        </div>

        {/* ソースフィルター */}
        <div className="mb-6">
          <RecipeFilters />
        </div>

        {/* レシピ一覧（無限スクロール対応） */}
        <RecipeList
          initialRecipes={initialRecipes}
          initialFilters={{ query, source, tag }}
          onLike={handleLike}
        />
      </main>

      <FloatingActionButton />
      <BottomNav />
    </>
  )
}
