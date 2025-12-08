'use client'

import { useEffect } from 'react'
import { addToHistory } from '@/lib/history'

interface HistoryTrackerProps {
  recipeId: number
}

export default function HistoryTracker({ recipeId }: HistoryTrackerProps) {
  useEffect(() => {
    addToHistory(recipeId)
  }, [recipeId])

  return null
}
