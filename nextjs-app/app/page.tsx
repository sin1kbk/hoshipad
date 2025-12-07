import { getAllRecipes, searchRecipes } from '@/lib/api/recipes'
import RecipeCard from '@/components/recipes/RecipeCard'
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

  const recipes = query || source || tag
    ? await searchRecipes({ query, source, tag })
    : await getAllRecipes()

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

        {/* レシピ一覧 */}
        {recipes.length === 0 ? (
          <div className="py-12 text-center">
            <p className="text-gray-500">レシピが見つかりませんでした</p>
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

      <FloatingActionButton />
      <BottomNav />
    </>
  )
}
