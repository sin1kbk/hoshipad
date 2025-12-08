export type RecipeSource = 'youtube' | 'instagram' | 'twitter' | 'cookpad'

export type RecipeCategory =
  | '肉料理'
  | '魚介料理'
  | '野菜料理'
  | 'サラダ'
  | 'ご飯もの'
  | '麺類'
  | 'スープ・汁物'
  | 'お菓子'
  | 'デザート'
  | 'パン'
  | 'お弁当'
  | 'その他'

export interface Ingredient {
  name: string
  amount: string
}

export interface Recipe {
  id: number
  title: string
  url: string
  image_url: string
  notes?: string
  source: RecipeSource
  tags?: string[]
  user_id?: string
  ingredients?: Ingredient[]
  like_count: number
  is_liked_by_current_user: boolean
  created_at: string
}

export interface InsertRecipe {
  title: string
  url: string
  image_url: string
  notes?: string
  source: RecipeSource
  tags?: string[]
  user_id?: string
  ingredients?: Ingredient[]
}

export interface UpdateRecipe {
  title?: string
  url?: string
  image_url?: string
  notes?: string
  source?: RecipeSource
  tags?: string[]
  ingredients?: Ingredient[]
}

export const RECIPE_SOURCES: { value: RecipeSource; label: string }[] = [
  { value: 'youtube', label: 'YouTube' },
  { value: 'instagram', label: 'Instagram' },
  { value: 'twitter', label: 'Twitter' },
  { value: 'cookpad', label: 'クックパッド' },
]

export const RECIPE_CATEGORIES: { value: RecipeCategory; label: string }[] = [
  { value: '肉料理', label: '肉料理' },
  { value: '魚介料理', label: '魚介料理' },
  { value: '野菜料理', label: '野菜料理' },
  { value: 'サラダ', label: 'サラダ' },
  { value: 'ご飯もの', label: 'ご飯もの' },
  { value: '麺類', label: '麺類' },
  { value: 'スープ・汁物', label: 'スープ・汁物' },
  { value: 'お菓子', label: 'お菓子' },
  { value: 'デザート', label: 'デザート' },
  { value: 'パン', label: 'パン' },
  { value: 'お弁当', label: 'お弁当' },
  { value: 'その他', label: 'その他' },
]
