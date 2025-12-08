import { notFound, redirect } from 'next/navigation'
import Image from 'next/image'
import Link from 'next/link'
import { getRecipeById, toggleLike, deleteRecipe } from '@/lib/api/recipes'
import { RECIPE_SOURCES } from '@/types/recipe'
import { createClient } from '@/lib/supabase/server'
import { Heart, ExternalLink, Edit, Trash2, ArrowLeft } from 'lucide-react'
import RecipeDetailClient from './RecipeDetailClient'
import HistoryTracker from './HistoryTracker'

export const dynamic = 'force-dynamic'

interface RecipeDetailPageProps {
  params: Promise<{ id: string }>
}

export default async function RecipeDetailPage({ params }: RecipeDetailPageProps) {
  const { id } = await params
  const recipeId = parseInt(id, 10)

  if (isNaN(recipeId)) {
    notFound()
  }

  const recipe = await getRecipeById(recipeId)

  if (!recipe) {
    notFound()
  }

  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  const isCreator = user?.id === recipe.user_id

  async function handleLike() {
    'use server'
    await toggleLike(recipeId)
  }

  async function handleDelete() {
    'use server'
    await deleteRecipe(recipeId)
    redirect('/')
  }

  const sourceLabel = RECIPE_SOURCES.find(s => s.value === recipe.source)?.label || recipe.source

  return (
    <div className="min-h-screen bg-gray-50">
      <HistoryTracker recipeId={recipeId} />
      {/* ヘッダー */}
      <div className="sticky top-0 z-10 bg-white shadow-sm">
        <div className="container mx-auto flex items-center justify-between px-4 py-3">
          <Link
            href="/"
            className="flex items-center text-gray-700 hover:text-primary transition-colors"
          >
            <ArrowLeft className="h-5 w-5 mr-2" />
            <span>戻る</span>
          </Link>
          {isCreator && (
            <div className="flex items-center gap-2">
              <Link
                href={`/recipes/${recipeId}/edit`}
                className="flex items-center px-3 py-1.5 text-sm text-gray-700 hover:text-primary transition-colors"
              >
                <Edit className="h-4 w-4 mr-1" />
                編集
              </Link>
            </div>
          )}
        </div>
      </div>

      {/* レシピ画像 */}
      <div className="relative w-full h-64 sm:h-80 md:h-96 bg-gray-100">
        <Image
          src={recipe.image_url}
          alt={recipe.title}
          fill
          className="object-cover"
          priority
        />
      </div>

      {/* レシピ情報 */}
      <div className="container mx-auto px-4 py-6 max-w-3xl">
        {/* タイトルとソース */}
        <div className="mb-4">
          <h1 className="text-2xl sm:text-3xl font-bold text-gray-900 mb-3">
            {recipe.title}
          </h1>
          <div className="flex items-center gap-3 flex-wrap">
            <span className="inline-flex items-center px-3 py-1 rounded-full bg-primary-50 text-primary text-sm font-medium">
              {sourceLabel}
            </span>
            {recipe.tags && recipe.tags.length > 0 && (
              <div className="flex flex-wrap gap-2">
                {recipe.tags.map((tag, index) => (
                  <span
                    key={index}
                    className="inline-flex items-center px-2 py-1 rounded-full bg-gray-100 text-gray-700 text-xs"
                  >
                    {tag}
                  </span>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* いいねボタン */}
        <RecipeDetailClient
          recipeId={recipeId}
          initialLikeCount={recipe.like_count}
          initialIsLiked={recipe.is_liked_by_current_user}
          onLike={handleLike}
        />

        {/* 材料 */}
        {recipe.ingredients && recipe.ingredients.length > 0 && (
          <div className="mt-6">
            <h2 className="text-xl font-bold text-gray-900 mb-3">材料</h2>
            <div className="overflow-hidden rounded-lg border border-gray-200 bg-white">
              <table className="w-full">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-4 py-3 text-left text-sm font-semibold text-gray-900 border-b border-gray-200">
                      材料名
                    </th>
                    <th className="px-4 py-3 text-left text-sm font-semibold text-gray-900 border-b border-gray-200">
                      分量
                    </th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-200">
                  {recipe.ingredients.map((ingredient, index) => (
                    <tr key={index} className="hover:bg-gray-50 transition-colors">
                      <td className="px-4 py-3 text-gray-900">{ingredient.name}</td>
                      <td className="px-4 py-3 text-gray-600">{ingredient.amount}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {/* メモ */}
        {recipe.notes && recipe.notes.trim() !== '' && (
          <div className="mt-6">
            <h2 className="text-xl font-bold text-gray-900 mb-3">メモ</h2>
            <p className="text-gray-700 whitespace-pre-wrap leading-relaxed">
              {recipe.notes}
            </p>
          </div>
        )}

        {/* レシピを見るボタン */}
        <div className="mt-8">
          <a
            href={recipe.url}
            target="_blank"
            rel="noopener noreferrer"
            className="flex items-center justify-center gap-2 w-full px-6 py-4 bg-primary text-white rounded-lg font-medium hover:bg-primary/90 transition-colors"
          >
            <ExternalLink className="h-5 w-5" />
            レシピを見る
          </a>
        </div>

        {/* 削除ボタン（作成者のみ） */}
        {isCreator && (
          <div className="mt-4">
            <form action={handleDelete}>
              <button
                type="submit"
                className="flex items-center justify-center gap-2 w-full px-6 py-3 text-red-600 border border-red-300 rounded-lg font-medium hover:bg-red-50 transition-colors"
                onClick={(e) => {
                  if (!confirm('このレシピを削除しますか？')) {
                    e.preventDefault()
                  }
                }}
              >
                <Trash2 className="h-4 w-4" />
                レシピを削除
              </button>
            </form>
          </div>
        )}
      </div>
    </div>
  )
}
