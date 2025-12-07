'use client'

import { RECIPE_CATEGORIES } from '@/types/recipe'
import { useRouter, useSearchParams } from 'next/navigation'
import {
  Beef, Fish, Salad, Rice, Noodles,
  Soup, Cake, Bread, Package, Utensils
} from 'lucide-react'

const categoryIcons: Record<string, any> = {
  '肉料理': Beef,
  '魚介料理': Fish,
  '野菜料理': Salad,
  'サラダ': Salad,
  'ご飯もの': Rice,
  '麺類': Noodles,
  'スープ・汁物': Soup,
  'お菓子': Cake,
  'デザート': Cake,
  'パン': Bread,
  'お弁当': Package,
  'その他': Utensils,
}

export default function CategoryFilter() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const selectedTag = searchParams.get('tag')

  const handleCategoryClick = (categoryValue: string) => {
    const params = new URLSearchParams(searchParams.toString())

    if (selectedTag === categoryValue) {
      params.delete('tag')
    } else {
      params.set('tag', categoryValue)
    }

    const query = params.toString()
    router.push(query ? `/?${query}` : '/')
  }

  return (
    <div className="mb-6">
      <h3 className="text-sm font-bold text-gray-900 mb-4 px-1">
        カテゴリーから探す
      </h3>

      <div className="overflow-x-auto pb-2 -mx-4 px-4">
        <div className="flex space-x-5 min-w-max">
          {RECIPE_CATEGORIES.map((category) => {
            const Icon = categoryIcons[category.value] || Utensils
            const isSelected = selectedTag === category.value

            return (
              <button
                key={category.value}
                onClick={() => handleCategoryClick(category.value)}
                className="flex flex-col items-center flex-shrink-0 group"
              >
                <div
                  className={`w-16 h-16 rounded-full flex items-center justify-center transition-all ${
                    isSelected
                      ? 'bg-primary shadow-lg'
                      : 'bg-orange-50 group-hover:bg-orange-100'
                  }`}
                >
                  <Icon
                    className={`h-8 w-8 ${
                      isSelected ? 'text-white' : 'text-primary'
                    }`}
                  />
                </div>
                <span
                  className={`mt-2 text-xs font-medium transition-colors ${
                    isSelected
                      ? 'text-primary font-bold'
                      : 'text-gray-700 group-hover:text-primary'
                  }`}
                >
                  {category.label}
                </span>
              </button>
            )
          })}
        </div>
      </div>
    </div>
  )
}
