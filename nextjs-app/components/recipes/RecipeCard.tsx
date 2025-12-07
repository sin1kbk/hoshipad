'use client'

import Image from 'next/image'
import Link from 'next/link'
import { Recipe, RECIPE_SOURCES } from '@/types/recipe'
import { Heart } from 'lucide-react'
import { useState } from 'react'

interface RecipeCardProps {
  recipe: Recipe
  onLike?: (recipeId: number) => Promise<void>
}

export default function RecipeCard({ recipe, onLike }: RecipeCardProps) {
  const [isLiked, setIsLiked] = useState(recipe.is_liked_by_current_user)
  const [likeCount, setLikeCount] = useState(recipe.like_count)
  const [isLiking, setIsLiking] = useState(false)

  const sourceLabel = RECIPE_SOURCES.find(s => s.value === recipe.source)?.label || recipe.source

  const handleLike = async (e: React.MouseEvent) => {
    e.preventDefault()
    if (isLiking || !onLike) return

    setIsLiking(true)
    const newIsLiked = !isLiked
    setIsLiked(newIsLiked)
    setLikeCount(prev => newIsLiked ? prev + 1 : prev - 1)

    try {
      await onLike(recipe.id)
    } catch (error) {
      setIsLiked(!newIsLiked)
      setLikeCount(prev => newIsLiked ? prev - 1 : prev + 1)
    } finally {
      setIsLiking(false)
    }
  }

  return (
    <Link href={`/recipes/${recipe.id}`} className="group block h-full w-full">
      <div className="flex h-full w-full flex-col overflow-hidden rounded-lg bg-white shadow-md transition-shadow hover:shadow-lg">
        <div className="relative aspect-[4/3] shrink-0 overflow-hidden bg-gray-100">
          <Image
            src={recipe.image_url}
            alt={recipe.title}
            fill
            className="object-cover transition-transform group-hover:scale-105"
            sizes="(max-width: 640px) 50vw, (max-width: 1024px) 50vw, 33vw"
          />
        </div>

        <div className="flex flex-1 flex-col p-3 sm:p-4">
          <h3 className="mb-2 line-clamp-2 min-h-[3rem] text-sm font-semibold text-gray-900 sm:min-h-[3.5rem] sm:text-lg">
            {recipe.title}
          </h3>

          <div className="mt-auto flex items-center justify-between gap-2 text-xs text-gray-600 sm:text-sm">
            <span className="truncate rounded-full bg-primary-50 px-2 py-1 text-xs text-primary sm:px-3 sm:text-sm">
              {sourceLabel}
            </span>

            <button
              onClick={handleLike}
              className="flex shrink-0 items-center space-x-1 transition-colors hover:text-primary"
              disabled={isLiking}
            >
              <Heart
                className={`h-4 w-4 sm:h-5 sm:w-5 ${isLiked ? 'fill-primary text-primary' : ''}`}
              />
              <span className="text-xs sm:text-sm">{likeCount}</span>
            </button>
          </div>

          {recipe.tags && recipe.tags.length > 0 && (
            <div className="mt-2 flex flex-wrap gap-1.5 sm:mt-3 sm:gap-2">
              {recipe.tags.slice(0, 3).map((tag, index) => (
                <span
                  key={index}
                  className="rounded-full bg-gray-100 px-2 py-1 text-xs text-gray-600"
                >
                  {tag}
                </span>
              ))}
            </div>
          )}
        </div>
      </div>
    </Link>
  )
}
