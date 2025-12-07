'use client'

import { useState } from 'react'
import { Heart } from 'lucide-react'

interface RecipeDetailClientProps {
  recipeId: number
  initialLikeCount: number
  initialIsLiked: boolean
  onLike: () => Promise<void>
}

export default function RecipeDetailClient({
  recipeId,
  initialLikeCount,
  initialIsLiked,
  onLike,
}: RecipeDetailClientProps) {
  const [isLiked, setIsLiked] = useState(initialIsLiked)
  const [likeCount, setLikeCount] = useState(initialLikeCount)
  const [isLiking, setIsLiking] = useState(false)

  const handleLike = async () => {
    if (isLiking) return

    setIsLiking(true)
    const newIsLiked = !isLiked
    setIsLiked(newIsLiked)
    setLikeCount((prev) => (newIsLiked ? prev + 1 : prev - 1))

    try {
      await onLike()
    } catch (error) {
      // エラー時は元に戻す
      setIsLiked(!newIsLiked)
      setLikeCount((prev) => (newIsLiked ? prev - 1 : prev + 1))
      console.error('Failed to toggle like:', error)
    } finally {
      setIsLiking(false)
    }
  }

  return (
    <button
      onClick={handleLike}
      disabled={isLiking}
      className="flex items-center gap-2 px-4 py-2 rounded-lg border border-gray-300 hover:border-primary transition-colors disabled:opacity-50"
    >
      <Heart
        className={`h-5 w-5 ${isLiked ? 'fill-primary text-primary' : 'text-gray-600'}`}
      />
      <span className="text-gray-700 font-medium">{likeCount}</span>
    </button>
  )
}
