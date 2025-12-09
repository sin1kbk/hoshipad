/**
 * レシピ作成API Routeのテスト
 */

import { POST } from '@/app/api/recipes/route'
import { createClient } from '@/lib/supabase/server'
import { NextRequest } from 'next/server'

// Supabaseクライアントのモック
jest.mock('@/lib/supabase/server', () => ({
  createClient: jest.fn(),
}))

describe('POST /api/recipes', () => {
  const mockSupabaseClient = {
    auth: {
      getUser: jest.fn(),
    },
    from: jest.fn(),
  }

  beforeEach(() => {
    jest.clearAllMocks()
    ;(createClient as jest.Mock).mockResolvedValue(mockSupabaseClient)
  })

  it('正常にレシピを作成できる', async () => {
    const mockUser = { id: 'user-123' }
    const mockRecipeData = {
      title: 'テストレシピ',
      url: 'https://example.com/recipe',
      image_url: 'https://example.com/image.jpg',
      source: 'cookpad',
      notes: 'テストメモ',
      tags: ['肉料理'],
      ingredients: [
        { name: 'にんじん', amount: '2本' },
      ],
    }

    const mockInsertedRecipe = {
      id: 1,
      ...mockRecipeData,
      user_id: mockUser.id,
      created_at: '2024-01-01T00:00:00.000Z',
    }

    mockSupabaseClient.auth.getUser.mockResolvedValue({
      data: { user: mockUser },
    })

    const mockInsert = {
      insert: jest.fn().mockReturnThis(),
      select: jest.fn().mockReturnThis(),
      single: jest.fn().mockResolvedValue({
        data: mockInsertedRecipe,
        error: null,
      }),
    }

    mockSupabaseClient.from.mockReturnValue(mockInsert)

    const request = new NextRequest('http://localhost:3000/api/recipes', {
      method: 'POST',
      body: JSON.stringify(mockRecipeData),
      headers: {
        'Content-Type': 'application/json',
      },
    })

    const response = await POST(request)
    const data = await response.json()

    expect(response.status).toBe(200)
    expect(data).toEqual(mockInsertedRecipe)
    expect(mockSupabaseClient.from).toHaveBeenCalledWith('recipes')
    expect(mockInsert.insert).toHaveBeenCalledWith({
      ...mockRecipeData,
      user_id: mockUser.id,
    })
  })

  it('認証されていないユーザーは401エラーを返す', async () => {
    mockSupabaseClient.auth.getUser.mockResolvedValue({
      data: { user: null },
    })

    const mockRecipeData = {
      title: 'テストレシピ',
      url: 'https://example.com/recipe',
      image_url: 'https://example.com/image.jpg',
      source: 'cookpad',
    }

    const request = new NextRequest('http://localhost:3000/api/recipes', {
      method: 'POST',
      body: JSON.stringify(mockRecipeData),
      headers: {
        'Content-Type': 'application/json',
      },
    })

    const response = await POST(request)
    const data = await response.json()

    expect(response.status).toBe(401)
    expect(data).toEqual({ error: 'Unauthorized' })
    expect(mockSupabaseClient.from).not.toHaveBeenCalled()
  })

  it('データベースエラーが発生した場合、500エラーを返す', async () => {
    const mockUser = { id: 'user-123' }
    const mockRecipeData = {
      title: 'テストレシピ',
      url: 'https://example.com/recipe',
      image_url: 'https://example.com/image.jpg',
      source: 'cookpad',
    }

    const mockError = {
      message: 'Database error',
      code: '23505',
    }

    mockSupabaseClient.auth.getUser.mockResolvedValue({
      data: { user: mockUser },
    })

    const mockInsert = {
      insert: jest.fn().mockReturnThis(),
      select: jest.fn().mockReturnThis(),
      single: jest.fn().mockResolvedValue({
        data: null,
        error: mockError,
      }),
    }

    mockSupabaseClient.from.mockReturnValue(mockInsert)

    const request = new NextRequest('http://localhost:3000/api/recipes', {
      method: 'POST',
      body: JSON.stringify(mockRecipeData),
      headers: {
        'Content-Type': 'application/json',
      },
    })

    const response = await POST(request)
    const data = await response.json()

    expect(response.status).toBe(500)
    expect(data).toEqual({ error: 'Database error' })
  })

  it('必須フィールドのみでレシピを作成できる', async () => {
    const mockUser = { id: 'user-123' }
    const mockRecipeData = {
      title: '最小限のレシピ',
      url: 'https://example.com/recipe',
      image_url: 'https://example.com/image.jpg',
      source: 'cookpad',
    }

    const mockInsertedRecipe = {
      id: 1,
      ...mockRecipeData,
      user_id: mockUser.id,
      created_at: '2024-01-01T00:00:00.000Z',
    }

    mockSupabaseClient.auth.getUser.mockResolvedValue({
      data: { user: mockUser },
    })

    const mockInsert = {
      insert: jest.fn().mockReturnThis(),
      select: jest.fn().mockReturnThis(),
      single: jest.fn().mockResolvedValue({
        data: mockInsertedRecipe,
        error: null,
      }),
    }

    mockSupabaseClient.from.mockReturnValue(mockInsert)

    const request = new NextRequest('http://localhost:3000/api/recipes', {
      method: 'POST',
      body: JSON.stringify(mockRecipeData),
      headers: {
        'Content-Type': 'application/json',
      },
    })

    const response = await POST(request)
    const data = await response.json()

    expect(response.status).toBe(200)
    expect(data.title).toBe(mockRecipeData.title)
    expect(data.url).toBe(mockRecipeData.url)
    expect(data.image_url).toBe(mockRecipeData.image_url)
    expect(data.source).toBe(mockRecipeData.source)
    expect(data.user_id).toBe(mockUser.id)
  })

  it('予期しないエラーが発生した場合、500エラーを返す', async () => {
    const mockUser = { id: 'user-123' }
    const mockRecipeData = {
      title: 'テストレシピ',
      url: 'https://example.com/recipe',
      image_url: 'https://example.com/image.jpg',
      source: 'cookpad',
    }

    mockSupabaseClient.auth.getUser.mockResolvedValue({
      data: { user: mockUser },
    })

    mockSupabaseClient.from.mockImplementation(() => {
      throw new Error('Unexpected error')
    })

    const request = new NextRequest('http://localhost:3000/api/recipes', {
      method: 'POST',
      body: JSON.stringify(mockRecipeData),
      headers: {
        'Content-Type': 'application/json',
      },
    })

    const response = await POST(request)
    const data = await response.json()

    expect(response.status).toBe(500)
    expect(data).toEqual({ error: 'Failed to create recipe' })
  })
})
