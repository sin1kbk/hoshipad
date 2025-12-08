import { createClient } from '@/lib/supabase/server'
import { NextRequest, NextResponse } from 'next/server'
import { searchRecipes, getAllRecipes } from '@/lib/api/recipes'
import { RecipeSource } from '@/types/recipe'

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams
    const query = searchParams.get('q') || undefined
    const source = searchParams.get('source') as RecipeSource | null
    const tag = searchParams.get('tag') || undefined
    const page = parseInt(searchParams.get('page') || '0', 10)
    const pageSize = parseInt(searchParams.get('pageSize') || '12', 10)

    const result = query || source || tag
      ? await searchRecipes({
          query,
          source: source || undefined,
          tag,
          page,
          pageSize,
        })
      : await getAllRecipes(page, pageSize)

    return NextResponse.json(result)
  } catch (error) {
    console.error('Error fetching recipes:', error)
    return NextResponse.json(
      { error: 'Failed to fetch recipes' },
      { status: 500 }
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const recipeData = {
      ...body,
      user_id: user.id,
    }

    const { data, error } = await supabase
      .from('recipes')
      .insert(recipeData)
      .select()
      .single()

    if (error) {
      console.error('Error creating recipe:', error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json(data)
  } catch (error) {
    console.error('Error creating recipe:', error)
    return NextResponse.json(
      { error: 'Failed to create recipe' },
      { status: 500 }
    )
  }
}
