import { notFound, redirect } from 'next/navigation'
import { getRecipeById } from '@/lib/api/recipes'
import { createClient } from '@/lib/supabase/server'
import EditRecipeForm from './EditRecipeForm'

export const dynamic = 'force-dynamic'

interface EditRecipePageProps {
  params: Promise<{ id: string }>
}

export default async function EditRecipePage({ params }: EditRecipePageProps) {
  const { id } = await params
  const recipeId = parseInt(id, 10)

  if (isNaN(recipeId)) {
    notFound()
  }

  const recipe = await getRecipeById(recipeId)

  if (!recipe) {
    notFound()
  }

  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user || user.id !== recipe.user_id) {
    redirect(`/recipes/${recipeId}`)
  }

  return <EditRecipeForm recipe={recipe} />
}
