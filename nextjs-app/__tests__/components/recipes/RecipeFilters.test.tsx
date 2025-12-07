import { render, screen, fireEvent } from '@testing-library/react'
import RecipeFilters from '@/components/recipes/RecipeFilters'
import { useRouter, useSearchParams } from 'next/navigation'

jest.mock('next/navigation')

describe('RecipeFilters', () => {
  const mockPush = jest.fn()
  const mockSearchParams = new URLSearchParams()

  beforeEach(() => {
    jest.clearAllMocks()
    ;(useRouter as jest.Mock).mockReturnValue({
      push: mockPush,
    })
    ;(useSearchParams as jest.Mock).mockReturnValue(mockSearchParams)
  })

  it('検索ボックスが表示される', () => {
    render(<RecipeFilters />)

    const searchInput = screen.getByPlaceholderText('レシピを検索...')
    expect(searchInput).toBeInTheDocument()
  })

  it('すべてのソースフィルターボタンが表示される', () => {
    render(<RecipeFilters />)

    expect(screen.getByText('すべて')).toBeInTheDocument()
    expect(screen.getByText('YouTube')).toBeInTheDocument()
    expect(screen.getByText('Instagram')).toBeInTheDocument()
    expect(screen.getByText('Twitter')).toBeInTheDocument()
    expect(screen.getByText('クックパッド')).toBeInTheDocument()
  })

  it('検索テキストを入力するとルーターが更新される', async () => {
    render(<RecipeFilters />)

    const searchInput = screen.getByPlaceholderText('レシピを検索...')
    fireEvent.change(searchInput, { target: { value: '肉じゃが' } })

    // useEffect内でrouterが呼ばれるまで待つ
    await new Promise(resolve => setTimeout(resolve, 100))

    expect(mockPush).toHaveBeenCalled()
  })

  it('ソースフィルターをクリックするとルーターが更新される', async () => {
    render(<RecipeFilters />)

    const youtubeButton = screen.getByText('YouTube')
    fireEvent.click(youtubeButton)

    await new Promise(resolve => setTimeout(resolve, 100))

    expect(mockPush).toHaveBeenCalled()
  })

  it('すべてボタンをクリックするとフィルターがクリアされる', async () => {
    render(<RecipeFilters />)

    // まずYouTubeを選択
    const youtubeButton = screen.getByText('YouTube')
    fireEvent.click(youtubeButton)

    // その後「すべて」を選択
    const allButton = screen.getByText('すべて')
    fireEvent.click(allButton)

    await new Promise(resolve => setTimeout(resolve, 100))

    expect(mockPush).toHaveBeenCalled()
  })

  it('選択されたソースボタンがハイライトされる', () => {
    const params = new URLSearchParams('source=youtube')
    ;(useSearchParams as jest.Mock).mockReturnValue(params)

    render(<RecipeFilters />)

    const youtubeButton = screen.getByText('YouTube')
    expect(youtubeButton).toHaveClass('bg-primary')
  })
})
