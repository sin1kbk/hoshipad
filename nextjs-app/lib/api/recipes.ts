import { createClient } from '@/lib/supabase/server'
import { Recipe, InsertRecipe, UpdateRecipe, RecipeSource } from '@/types/recipe'

export async function getAllRecipes(): Promise<Recipe[]> {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  const { data, error } = await supabase
    .from('recipes')
    .select(`
      *,
      recipe_likes(user_id)
    `)
    .order('created_at', { ascending: false })

  if (error) throw error

  return parseRecipesWithLikes(data || [], user?.id)
}

export async function getUserRecipes(userId: string): Promise<Recipe[]> {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  const { data, error } = await supabase
    .from('recipes')
    .select(`
      *,
      recipe_likes(user_id)
    `)
    .eq('user_id', userId)
    .order('created_at', { ascending: false })

  if (error) throw error

  return parseRecipesWithLikes(data || [], user?.id)
}

export async function searchRecipes(params: {
  query?: string
  source?: RecipeSource
  tag?: string
}): Promise<Recipe[]> {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  let queryBuilder = supabase
    .from('recipes')
    .select(`
      *,
      recipe_likes(user_id)
    `)

  if (params.source) {
    queryBuilder = queryBuilder.eq('source', params.source)
  }

  if (params.tag) {
    queryBuilder = queryBuilder.contains('tags', [params.tag])
  }

  if (params.query) {
    queryBuilder = queryBuilder.or(
      `title.ilike.%${params.query}%,notes.ilike.%${params.query}%`
    )
  }

  const { data, error } = await queryBuilder.order('created_at', { ascending: false })

  if (error) throw error

  return parseRecipesWithLikes(data || [], user?.id)
}

export async function createRecipe(recipe: InsertRecipe): Promise<Recipe> {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  const recipeWithUser = {
    ...recipe,
    user_id: user?.id,
  }

  const { data, error } = await supabase
    .from('recipes')
    .insert(recipeWithUser)
    .select()
    .single()

  if (error) throw error

  return {
    ...data,
    like_count: 0,
    is_liked_by_current_user: false,
  }
}

export async function updateRecipe(id: number, recipe: UpdateRecipe): Promise<Recipe> {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('recipes')
    .update(recipe)
    .eq('id', id)
    .select()
    .single()

  if (error) throw error

  return {
    ...data,
    like_count: 0,
    is_liked_by_current_user: false,
  }
}

export async function deleteRecipe(id: number): Promise<void> {
  const supabase = await createClient()

  const { error } = await supabase
    .from('recipes')
    .delete()
    .eq('id', id)

  if (error) throw error
}

export async function toggleLike(recipeId: number): Promise<void> {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) throw new Error('User not authenticated')

  const { data: existingLike } = await supabase
    .from('recipe_likes')
    .select()
    .eq('recipe_id', recipeId)
    .eq('user_id', user.id)
    .single()

  if (existingLike) {
    const { error } = await supabase
      .from('recipe_likes')
      .delete()
      .eq('recipe_id', recipeId)
      .eq('user_id', user.id)

    if (error) throw error
  } else {
    const { error } = await supabase
      .from('recipe_likes')
      .insert({ recipe_id: recipeId, user_id: user.id })

    if (error) throw error
  }
}

function parseRecipesWithLikes(recipes: any[], currentUserId?: string): Recipe[] {
  return recipes.map((recipe) => {
    const likes = recipe.recipe_likes || []
    const likeCount = likes.length
    const isLiked = currentUserId
      ? likes.some((like: any) => like.user_id === currentUserId)
      : false

    const { recipe_likes, ...recipeData } = recipe

    return {
      ...recipeData,
      like_count: likeCount,
      is_liked_by_current_user: isLiked,
    }
  })
}
