'use client'

import { RecipeSource, RECIPE_SOURCES } from '@/types/recipe'
import { useRouter, useSearchParams } from 'next/navigation'
import { useState, useEffect } from 'react'

export default function RecipeFilters() {
  const router = useRouter()
  const searchParams = useSearchParams()

  const [source, setSource] = useState<RecipeSource | ''>(
    (searchParams.get('source') as RecipeSource) || ''
  )

  useEffect(() => {
    const params = new URLSearchParams(searchParams.toString())

    if (source) {
      params.set('source', source)
    } else {
      params.delete('source')
    }

    const newUrl = params.toString() ? `/?${params.toString()}` : '/'
    router.push(newUrl)
  }, [source, router, searchParams])

  return (
    <div className="flex flex-wrap gap-2">
      <button
        onClick={() => setSource('')}
        className={`rounded-full px-4 py-2 text-sm font-medium transition-colors ${
          source === ''
            ? 'bg-primary text-white shadow-md'
            : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
        }`}
      >
        すべて
      </button>
      {RECIPE_SOURCES.map((s) => (
        <button
          key={s.value}
          onClick={() => setSource(s.value)}
          className={`rounded-full px-4 py-2 text-sm font-medium transition-colors ${
            source === s.value
              ? 'bg-primary text-white shadow-md'
              : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
          }`}
        >
          {s.label}
        </button>
      ))}
    </div>
  )
}
