import { Recipe, RecipeSource } from './recipe'

export interface Database {
  public: {
    Tables: {
      recipes: {
        Row: Recipe
        Insert: Omit<Recipe, 'id' | 'like_count' | 'is_liked_by_current_user' | 'created_at'>
        Update: Partial<Omit<Recipe, 'id' | 'like_count' | 'is_liked_by_current_user' | 'created_at'>>
      }
      recipe_likes: {
        Row: {
          recipe_id: number
          user_id: string
          created_at: string
        }
        Insert: {
          recipe_id: number
          user_id: string
        }
        Update: never
      }
    }
    Views: {}
    Functions: {}
    Enums: {
      recipe_source: RecipeSource
    }
  }
}
