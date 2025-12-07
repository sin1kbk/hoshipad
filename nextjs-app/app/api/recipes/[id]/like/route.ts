import { NextRequest, NextResponse } from 'next/server'
import { toggleLike } from '@/lib/api/recipes'

export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params
    const recipeId = parseInt(id, 10)

    if (isNaN(recipeId)) {
      return NextResponse.json({ error: 'Invalid recipe ID' }, { status: 400 })
    }

    await toggleLike(recipeId)

    return NextResponse.json({ success: true })
  } catch (error) {
    console.error('Error toggling like:', error)
    return NextResponse.json(
      { error: 'Failed to toggle like' },
      { status: 500 }
    )
  }
}
