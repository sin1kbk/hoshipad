'use client'

import { useState } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import Header from '@/components/layout/Header'
import {
  RECIPE_SOURCES,
  RECIPE_CATEGORIES,
  RecipeSource,
  RecipeCategory,
  Ingredient,
} from '@/types/recipe'
import { Plus, Trash2 } from 'lucide-react'

export default function AddRecipePage() {
  const router = useRouter()
  const searchParams = useSearchParams()

  const [url, setUrl] = useState(searchParams.get('url') || '')
  const [title, setTitle] = useState(searchParams.get('title') || '')
  const [imageUrl, setImageUrl] = useState(searchParams.get('image') || '')
  const [source, setSource] = useState<RecipeSource>('cookpad')
  const [notes, setNotes] = useState('')
  const [tags, setTags] = useState<string[]>([])
  const [tagInput, setTagInput] = useState('')
  const [ingredients, setIngredients] = useState<Ingredient[]>([])
  const [isLoading, setIsLoading] = useState(false)
  const [isScraping, setIsScraping] = useState(false)

  const handleScrape = async () => {
    if (!url || !url.includes('cookpad.com')) {
      alert('CookpadのURLを入力してください')
      return
    }

    setIsScraping(true)
    try {
      const response = await fetch('/api/scrape', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ url }),
      })

      if (!response.ok) throw new Error('スクレイピングに失敗しました')

      const data = await response.json()
      setTitle(data.title || '')
      setImageUrl(data.imageUrl || '')
      setIngredients(data.ingredients || [])
      if (data.suggestedCategory) {
        setTags([data.suggestedCategory])
      }
    } catch (error) {
      alert('レシピ情報の取得に失敗しました')
    } finally {
      setIsScraping(false)
    }
  }

  const handleAddTag = () => {
    if (tagInput && !tags.includes(tagInput)) {
      setTags([...tags, tagInput])
      setTagInput('')
    }
  }

  const handleRemoveTag = (tag: string) => {
    setTags(tags.filter((t) => t !== tag))
  }

  const handleAddIngredient = () => {
    setIngredients([...ingredients, { name: '', amount: '' }])
  }

  const handleRemoveIngredient = (index: number) => {
    setIngredients(ingredients.filter((_, i) => i !== index))
  }

  const handleIngredientChange = (
    index: number,
    field: 'name' | 'amount',
    value: string
  ) => {
    const newIngredients = [...ingredients]
    newIngredients[index][field] = value
    setIngredients(newIngredients)
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    if (!title || !url || !imageUrl) {
      alert('タイトル、URL、画像URLは必須です')
      return
    }

    setIsLoading(true)
    try {
      const response = await fetch('/api/recipes', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          title,
          url,
          image_url: imageUrl,
          source,
          notes: notes || undefined,
          tags: tags.length > 0 ? tags : undefined,
          ingredients: ingredients.filter((i) => i.name && i.amount),
        }),
      })

      if (!response.ok) throw new Error('レシピの作成に失敗しました')

      router.push('/')
    } catch (error) {
      alert('レシピの作成に失敗しました')
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <>
      <Header />
      <main className="container mx-auto max-w-3xl px-4 py-8">
        <h1 className="mb-8 text-3xl font-bold text-gray-900">レシピを追加</h1>

        <form onSubmit={handleSubmit} className="space-y-6">
          {/* URL */}
          <div>
            <label className="mb-2 block text-sm font-medium text-gray-700">
              レシピURL *
            </label>
            <div className="flex space-x-2">
              <input
                type="url"
                value={url}
                onChange={(e) => setUrl(e.target.value)}
                className="flex-1 rounded-lg border border-gray-300 px-3 py-2 focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary"
                required
              />
              <button
                type="button"
                onClick={handleScrape}
                disabled={isScraping}
                className="rounded-lg bg-primary px-4 py-2 text-sm font-medium text-white hover:bg-primary-600 disabled:opacity-50"
              >
                {isScraping ? '取得中...' : '情報を取得'}
              </button>
            </div>
          </div>

          {/* タイトル */}
          <div>
            <label className="mb-2 block text-sm font-medium text-gray-700">
              タイトル *
            </label>
            <input
              type="text"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary"
              required
            />
          </div>

          {/* 画像URL */}
          <div>
            <label className="mb-2 block text-sm font-medium text-gray-700">
              画像URL *
            </label>
            <input
              type="url"
              value={imageUrl}
              onChange={(e) => setImageUrl(e.target.value)}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary"
              required
            />
          </div>

          {/* ソース */}
          <div>
            <label className="mb-2 block text-sm font-medium text-gray-700">
              ソース *
            </label>
            <select
              value={source}
              onChange={(e) => setSource(e.target.value as RecipeSource)}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary"
            >
              {RECIPE_SOURCES.map((s) => (
                <option key={s.value} value={s.value}>
                  {s.label}
                </option>
              ))}
            </select>
          </div>

          {/* メモ */}
          <div>
            <label className="mb-2 block text-sm font-medium text-gray-700">
              メモ
            </label>
            <textarea
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              rows={4}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary"
            />
          </div>

          {/* タグ */}
          <div>
            <label className="mb-2 block text-sm font-medium text-gray-700">
              タグ
            </label>
            <div className="flex space-x-2">
              <select
                value={tagInput}
                onChange={(e) => setTagInput(e.target.value)}
                className="flex-1 rounded-lg border border-gray-300 px-3 py-2 focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary"
              >
                <option value="">タグを選択</option>
                {RECIPE_CATEGORIES.map((cat) => (
                  <option key={cat.value} value={cat.value}>
                    {cat.label}
                  </option>
                ))}
              </select>
              <button
                type="button"
                onClick={handleAddTag}
                className="rounded-lg bg-gray-200 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-300"
              >
                追加
              </button>
            </div>
            <div className="mt-2 flex flex-wrap gap-2">
              {tags.map((tag) => (
                <span
                  key={tag}
                  className="inline-flex items-center rounded-full bg-primary-50 px-3 py-1 text-sm text-primary"
                >
                  {tag}
                  <button
                    type="button"
                    onClick={() => handleRemoveTag(tag)}
                    className="ml-2 text-primary-600 hover:text-primary-700"
                  >
                    ×
                  </button>
                </span>
              ))}
            </div>
          </div>

          {/* 材料 */}
          <div>
            <div className="mb-2 flex items-center justify-between">
              <label className="block text-sm font-medium text-gray-700">
                材料
              </label>
              <button
                type="button"
                onClick={handleAddIngredient}
                className="flex items-center space-x-1 text-sm text-primary hover:text-primary-600"
              >
                <Plus className="h-4 w-4" />
                <span>追加</span>
              </button>
            </div>
            <div className="space-y-2">
              {ingredients.map((ingredient, index) => (
                <div key={index} className="flex space-x-2">
                  <input
                    type="text"
                    placeholder="名前"
                    value={ingredient.name}
                    onChange={(e) =>
                      handleIngredientChange(index, 'name', e.target.value)
                    }
                    className="flex-1 rounded-lg border border-gray-300 px-3 py-2 focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                  <input
                    type="text"
                    placeholder="分量"
                    value={ingredient.amount}
                    onChange={(e) =>
                      handleIngredientChange(index, 'amount', e.target.value)
                    }
                    className="w-32 rounded-lg border border-gray-300 px-3 py-2 focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                  <button
                    type="button"
                    onClick={() => handleRemoveIngredient(index)}
                    className="rounded-lg p-2 text-red-500 hover:bg-red-50"
                  >
                    <Trash2 className="h-5 w-5" />
                  </button>
                </div>
              ))}
            </div>
          </div>

          {/* 送信ボタン */}
          <div className="flex justify-end space-x-4">
            <button
              type="button"
              onClick={() => router.back()}
              className="rounded-lg border border-gray-300 px-6 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
            >
              キャンセル
            </button>
            <button
              type="submit"
              disabled={isLoading}
              className="rounded-lg bg-primary px-6 py-2 text-sm font-medium text-white hover:bg-primary-600 disabled:opacity-50"
            >
              {isLoading ? '作成中...' : 'レシピを作成'}
            </button>
          </div>
        </form>
      </main>
    </>
  )
}
