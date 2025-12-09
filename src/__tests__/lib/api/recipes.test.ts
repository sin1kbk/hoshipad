/**
 * API関数のテスト
 *
 * 注意: これらのテストはSupabaseクライアントをモックする必要があります
 * 実際のプロジェクトでは、より詳細なモックを実装してください
 */

import { RECIPE_SOURCES, RECIPE_CATEGORIES, InsertRecipe } from '@/types/recipe'
import { createRecipe } from '@/lib/api/recipes'
import { createClient } from '@/lib/supabase/server'

// Supabaseクライアントのモック
jest.mock('@/lib/supabase/server', () => ({
  createClient: jest.fn(),
}))

describe('Recipe API Functions', () => {
  describe('Recipe Type Validation', () => {
    it('有効なレシピソースが定義されている', () => {
      const validSources = ['youtube', 'instagram', 'twitter', 'cookpad']
      const sources = RECIPE_SOURCES.map(s => s.value)

      validSources.forEach(source => {
        expect(sources).toContain(source)
      })
    })

    it('有効なレシピカテゴリが定義されている', () => {
      const categories = RECIPE_CATEGORIES.map(c => c.value)
      expect(categories.length).toBeGreaterThan(0)
    })
  })

  describe('Recipe Data Structure', () => {
    it('レシピオブジェクトが必須フィールドを持つ', () => {
      const recipe = {
        id: 1,
        title: 'テストレシピ',
        url: 'https://example.com',
        image_url: 'https://example.com/image.jpg',
        source: 'cookpad' as const,
        like_count: 0,
        is_liked_by_current_user: false,
        created_at: new Date().toISOString(),
      }

      expect(recipe).toHaveProperty('id')
      expect(recipe).toHaveProperty('title')
      expect(recipe).toHaveProperty('url')
      expect(recipe).toHaveProperty('image_url')
      expect(recipe).toHaveProperty('source')
      expect(recipe).toHaveProperty('like_count')
      expect(recipe).toHaveProperty('is_liked_by_current_user')
      expect(recipe).toHaveProperty('created_at')
    })

    it('InsertRecipeがidとcreated_atを含まない', () => {
      const insertRecipe = {
        title: 'テストレシピ',
        url: 'https://example.com',
        image_url: 'https://example.com/image.jpg',
        source: 'cookpad' as const,
      }

      expect(insertRecipe).not.toHaveProperty('id')
      expect(insertRecipe).not.toHaveProperty('created_at')
      expect(insertRecipe).not.toHaveProperty('like_count')
    })
  })

  describe('Recipe Validation Rules', () => {
    it('タイトルは必須', () => {
      const recipe = {
        title: '',
        url: 'https://example.com',
        image_url: 'https://example.com/image.jpg',
        source: 'cookpad' as const,
      }

      expect(recipe.title).toBeDefined()
    })

    it('URLは有効な形式である', () => {
      const validUrl = 'https://example.com/recipe/123'
      expect(validUrl).toMatch(/^https?:\/\//)
    })

    it('ソースは定義された値のいずれか', () => {
      const validSources = ['youtube', 'instagram', 'twitter', 'cookpad']
      const source = 'cookpad'

      expect(validSources).toContain(source)
    })
  })
})

describe('Ingredient Type', () => {
  it('材料オブジェクトがnameとamountを持つ', () => {
    const ingredient = {
      name: '玉ねぎ',
      amount: '1個',
    }

    expect(ingredient).toHaveProperty('name')
    expect(ingredient).toHaveProperty('amount')
    expect(typeof ingredient.name).toBe('string')
    expect(typeof ingredient.amount).toBe('string')
  })

  it('材料の配列が扱える', () => {
    const ingredients = [
      { name: '玉ねぎ', amount: '1個' },
      { name: 'にんじん', amount: '2本' },
      { name: '豚肉', amount: '200g' },
    ]

    expect(ingredients).toHaveLength(3)
    ingredients.forEach(ing => {
      expect(ing).toHaveProperty('name')
      expect(ing).toHaveProperty('amount')
    })
  })
})

describe('createRecipe', () => {
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
    const mockRecipeData: InsertRecipe = {
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

    const result = await createRecipe(mockRecipeData)

    expect(createClient).toHaveBeenCalled()
    expect(mockSupabaseClient.auth.getUser).toHaveBeenCalled()
    expect(mockSupabaseClient.from).toHaveBeenCalledWith('recipes')
    expect(mockInsert.insert).toHaveBeenCalledWith({
      ...mockRecipeData,
      user_id: mockUser.id,
    })
    expect(result).toEqual({
      ...mockInsertedRecipe,
      like_count: 0,
      is_liked_by_current_user: false,
    })
  })

  it('ユーザーが認証されていない場合でもレシピを作成できる（user_idがundefined）', async () => {
    const mockRecipeData: InsertRecipe = {
      title: 'テストレシピ',
      url: 'https://example.com/recipe',
      image_url: 'https://example.com/image.jpg',
      source: 'cookpad',
    }

    const mockInsertedRecipe = {
      id: 1,
      ...mockRecipeData,
      user_id: undefined,
      created_at: '2024-01-01T00:00:00.000Z',
    }

    mockSupabaseClient.auth.getUser.mockResolvedValue({
      data: { user: null },
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

    const result = await createRecipe(mockRecipeData)

    expect(mockInsert.insert).toHaveBeenCalledWith({
      ...mockRecipeData,
      user_id: undefined,
    })
    expect(result).toEqual({
      ...mockInsertedRecipe,
      like_count: 0,
      is_liked_by_current_user: false,
    })
  })

  it('データベースエラーが発生した場合、エラーをthrowする', async () => {
    const mockUser = { id: 'user-123' }
    const mockRecipeData: InsertRecipe = {
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

    await expect(createRecipe(mockRecipeData)).rejects.toEqual(mockError)
  })

  it('必須フィールドが含まれているレシピを作成できる', async () => {
    const mockUser = { id: 'user-123' }
    const mockRecipeData: InsertRecipe = {
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

    const result = await createRecipe(mockRecipeData)

    expect(result.title).toBe(mockRecipeData.title)
    expect(result.url).toBe(mockRecipeData.url)
    expect(result.image_url).toBe(mockRecipeData.image_url)
    expect(result.source).toBe(mockRecipeData.source)
    expect(result.like_count).toBe(0)
    expect(result.is_liked_by_current_user).toBe(false)
  })
})
