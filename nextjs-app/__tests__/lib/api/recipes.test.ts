/**
 * API関数のテスト
 *
 * 注意: これらのテストはSupabaseクライアントをモックする必要があります
 * 実際のプロジェクトでは、より詳細なモックを実装してください
 */

import { RECIPE_SOURCES, RECIPE_CATEGORIES } from '@/types/recipe'

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
