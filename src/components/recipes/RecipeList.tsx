'use client'

import { useEffect, useRef, useState, useCallback } from 'react'
import RecipeCard from './RecipeCard'
import { Recipe, RecipeSource } from '@/types/recipe'

interface RecipeListProps {
  initialRecipes: Recipe[]
  initialFilters: {
    query?: string
    source?: RecipeSource
    tag?: string
  }
  onLike: (recipeId: number) => Promise<void>
}

const PAGE_SIZE = 12

export default function RecipeList({ initialRecipes, initialFilters, onLike }: RecipeListProps) {
  const [recipes, setRecipes] = useState<Recipe[]>(initialRecipes)
  const [page, setPage] = useState(0)
  const [hasMore, setHasMore] = useState(initialRecipes.length === PAGE_SIZE)
  const [isLoading, setIsLoading] = useState(false)
  const [filters, setFilters] = useState(initialFilters)
  const observerTarget = useRef<HTMLDivElement>(null)

  // フィルターが変更されたときにリセット
  useEffect(() => {
    const filtersChanged =
      filters.query !== initialFilters.query ||
      filters.source !== initialFilters.source ||
      filters.tag !== initialFilters.tag

    if (filtersChanged) {
      setFilters(initialFilters)
      setRecipes(initialRecipes)
      setPage(0)
      setHasMore(initialRecipes.length === PAGE_SIZE)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [initialFilters.query, initialFilters.source, initialFilters.tag])

  const loadMore = useCallback(async () => {
    if (isLoading || !hasMore) return

    setIsLoading(true)
    try {
      const nextPage = page + 1
      const params = new URLSearchParams()
      if (filters.query) params.set('q', filters.query)
      if (filters.source) params.set('source', filters.source)
      if (filters.tag) params.set('tag', filters.tag)
      params.set('page', nextPage.toString())
      params.set('pageSize', PAGE_SIZE.toString())

      const response = await fetch(`/api/recipes?${params.toString()}`)
      const data = await response.json()

      if (data.recipes && data.recipes.length > 0) {
        setRecipes((prev) => [...prev, ...data.recipes])
        setPage(nextPage)
        setHasMore(data.hasMore)
      } else {
        setHasMore(false)
      }
    } catch (error) {
      console.error('Failed to load more recipes:', error)
      setHasMore(false)
    } finally {
      setIsLoading(false)
    }
  }, [page, hasMore, isLoading, filters])

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && hasMore && !isLoading) {
          loadMore()
        }
      },
      { threshold: 0.1 }
    )

    const currentTarget = observerTarget.current
    if (currentTarget) {
      observer.observe(currentTarget)
    }

    return () => {
      if (currentTarget) {
        observer.unobserve(currentTarget)
      }
    }
  }, [hasMore, isLoading, loadMore])

  if (recipes.length === 0) {
    return (
      <div className="py-12 text-center">
        <p className="text-gray-500">レシピが見つかりませんでした</p>
      </div>
    )
  }

  return (
    <>
      <div className="grid grid-cols-2 gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        {recipes.map((recipe) => (
          <div key={recipe.id} className="flex w-full">
            <RecipeCard recipe={recipe} onLike={onLike} />
          </div>
        ))}
      </div>

      {/* 無限スクロール用の監視要素 */}
      {hasMore && (
        <div ref={observerTarget} className="py-8 text-center">
          {isLoading && (
            <div className="text-gray-500">読み込み中...</div>
          )}
        </div>
      )}
    </>
  )
}
