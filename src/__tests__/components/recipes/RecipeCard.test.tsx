import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import '@testing-library/jest-dom'
import RecipeCard from '@/components/recipes/RecipeCard'
import { Recipe } from '@/types/recipe'

const mockRecipe: Recipe = {
  id: 1,
  title: 'テストレシピ',
  url: 'https://example.com/recipe/1',
  image_url: 'https://example.com/image.jpg',
  source: 'cookpad',
  notes: 'テストメモ',
  tags: ['肉料理', 'お弁当'],
  like_count: 5,
  is_liked_by_current_user: false,
  created_at: '2024-01-01T00:00:00Z',
}

describe('RecipeCard', () => {
  it('レシピの情報が正しく表示される', () => {
    render(<RecipeCard recipe={mockRecipe} />)

    expect(screen.getByText('テストレシピ')).toBeInTheDocument()
    expect(screen.getByText('クックパッド')).toBeInTheDocument()
    expect(screen.getByText('5')).toBeInTheDocument()
    expect(screen.getByText('肉料理')).toBeInTheDocument()
    expect(screen.getByText('お弁当')).toBeInTheDocument()
  })

  it('画像が正しいURLで表示される', () => {
    render(<RecipeCard recipe={mockRecipe} />)

    const image = screen.getByAltText('テストレシピ')
    expect(image).toBeInTheDocument()
  })

  it('いいねボタンをクリックするとonLikeが呼ばれる', async () => {
    const mockOnLike = jest.fn().mockResolvedValue(undefined)
    render(<RecipeCard recipe={mockRecipe} onLike={mockOnLike} />)

    const likeButton = screen.getByRole('button')
    fireEvent.click(likeButton)

    await waitFor(() => {
      expect(mockOnLike).toHaveBeenCalledWith(1)
    })
  })

  it('いいね済みの場合、ハートが塗りつぶされる', () => {
    const likedRecipe = { ...mockRecipe, is_liked_by_current_user: true }
    render(<RecipeCard recipe={likedRecipe} />)

    const likeButton = screen.getByRole('button')
    const heart = likeButton.querySelector('svg')
    expect(heart).toHaveClass('fill-primary')
  })

  it('タグが3つ以上ある場合、最初の3つだけ表示される', () => {
    const recipeWithManyTags = {
      ...mockRecipe,
      tags: ['肉料理', 'お弁当', '野菜料理', 'デザート'],
    }
    render(<RecipeCard recipe={recipeWithManyTags} />)

    expect(screen.getByText('肉料理')).toBeInTheDocument()
    expect(screen.getByText('お弁当')).toBeInTheDocument()
    expect(screen.getByText('野菜料理')).toBeInTheDocument()
    expect(screen.queryByText('デザート')).not.toBeInTheDocument()
  })

  it('レシピカードをクリックすると詳細ページに遷移する', () => {
    const { container } = render(<RecipeCard recipe={mockRecipe} />)

    const link = container.querySelector('a')
    expect(link).toHaveAttribute('href', '/recipes/1')
  })
})
