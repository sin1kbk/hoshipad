import {
  getHistory,
  addToHistory,
  clearHistory,
  getHistoryRecipeIds,
} from '@/lib/history'

// localStorageのモック
const localStorageMock = (() => {
  let store: Record<string, string> = {}

  return {
    getItem: (key: string) => store[key] || null,
    setItem: (key: string, value: string) => {
      store[key] = value.toString()
    },
    removeItem: (key: string) => {
      delete store[key]
    },
    clear: () => {
      store = {}
    },
  }
})()

Object.defineProperty(window, 'localStorage', {
  value: localStorageMock,
})

describe('履歴機能', () => {
  beforeEach(() => {
    localStorageMock.clear()
  })

  describe('getHistory', () => {
    it('空の履歴を返す', () => {
      expect(getHistory()).toEqual([])
    })

    it('保存された履歴を取得できる', () => {
      const history = [
        { recipe_id: 1, viewed_at: '2024-01-01T00:00:00.000Z' },
        { recipe_id: 2, viewed_at: '2024-01-02T00:00:00.000Z' },
      ]
      localStorageMock.setItem('hoshipad_history', JSON.stringify(history))
      expect(getHistory()).toEqual(history)
    })
  })

  describe('addToHistory', () => {
    it('新しいレシピを履歴に追加できる', () => {
      addToHistory(1)
      const history = getHistory()
      expect(history).toHaveLength(1)
      expect(history[0].recipe_id).toBe(1)
    })

    it('既存のレシピを先頭に移動する', () => {
      addToHistory(1)
      addToHistory(2)
      addToHistory(1) // 1を再度追加

      const history = getHistory()
      expect(history).toHaveLength(2)
      expect(history[0].recipe_id).toBe(1)
      expect(history[1].recipe_id).toBe(2)
    })

    it('最大50件まで保存する', () => {
      for (let i = 1; i <= 60; i++) {
        addToHistory(i)
      }

      const history = getHistory()
      expect(history).toHaveLength(50)
      expect(history[0].recipe_id).toBe(60)
      expect(history[49].recipe_id).toBe(11)
    })
  })

  describe('clearHistory', () => {
    it('履歴をクリアできる', () => {
      addToHistory(1)
      addToHistory(2)
      expect(getHistory()).toHaveLength(2)

      clearHistory()
      expect(getHistory()).toEqual([])
    })
  })

  describe('getHistoryRecipeIds', () => {
    it('レシピIDの配列を返す', () => {
      addToHistory(1)
      addToHistory(2)
      addToHistory(3)

      const ids = getHistoryRecipeIds()
      expect(ids).toEqual([3, 2, 1]) // 新しい順
    })
  })
})
