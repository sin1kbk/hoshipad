import { RECIPE_SOURCES, RECIPE_CATEGORIES } from '@/types/recipe'

describe('Recipe Types', () => {
  describe('RECIPE_SOURCES', () => {
    it('4つのソースが定義されている', () => {
      expect(RECIPE_SOURCES).toHaveLength(4)
    })

    it('すべてのソースにvalueとlabelがある', () => {
      RECIPE_SOURCES.forEach(source => {
        expect(source).toHaveProperty('value')
        expect(source).toHaveProperty('label')
        expect(typeof source.value).toBe('string')
        expect(typeof source.label).toBe('string')
      })
    })

    it('期待されるソースが含まれている', () => {
      const values = RECIPE_SOURCES.map(s => s.value)
      expect(values).toContain('youtube')
      expect(values).toContain('instagram')
      expect(values).toContain('twitter')
      expect(values).toContain('cookpad')
    })
  })

  describe('RECIPE_CATEGORIES', () => {
    it('12のカテゴリが定義されている', () => {
      expect(RECIPE_CATEGORIES).toHaveLength(12)
    })

    it('すべてのカテゴリにvalueとlabelがある', () => {
      RECIPE_CATEGORIES.forEach(category => {
        expect(category).toHaveProperty('value')
        expect(category).toHaveProperty('label')
        expect(typeof category.value).toBe('string')
        expect(typeof category.label).toBe('string')
      })
    })

    it('期待されるカテゴリが含まれている', () => {
      const values = RECIPE_CATEGORIES.map(c => c.value)
      expect(values).toContain('肉料理')
      expect(values).toContain('魚介料理')
      expect(values).toContain('野菜料理')
      expect(values).toContain('その他')
    })
  })
})
