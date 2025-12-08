import { Recipe } from './recipe'

export interface HistoryItem {
  recipe_id: number
  viewed_at: string
  recipe?: Recipe
}
