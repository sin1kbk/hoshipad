import {
  getShoppingList,
  addShoppingItem,
  toggleShoppingItem,
  deleteShoppingItem,
  clearShoppingList,
  saveShoppingList,
} from '@/lib/shopping'
import { ShoppingItem } from '@/types/shopping'

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

// crypto.randomUUIDのモック
Object.defineProperty(global, 'crypto', {
  value: {
    randomUUID: () => {
      return 'test-uuid-' + Math.random().toString(36).substring(7)
    },
  },
})

Object.defineProperty(window, 'localStorage', {
  value: localStorageMock,
})

describe('買い物リスト機能', () => {
  beforeEach(() => {
    localStorageMock.clear()
  })

  describe('getShoppingList', () => {
    it('空のリストを返す', () => {
      expect(getShoppingList()).toEqual([])
    })

    it('保存されたリストを取得できる', () => {
      const items: ShoppingItem[] = [
        {
          id: '1',
          name: 'にんじん',
          amount: '2本',
          checked: false,
          created_at: '2024-01-01T00:00:00.000Z',
        },
      ]
      localStorageMock.setItem('hoshipad_shopping_list', JSON.stringify(items))
      expect(getShoppingList()).toEqual(items)
    })
  })

  describe('addShoppingItem', () => {
    it('新しいアイテムを追加できる', () => {
      const item = addShoppingItem('にんじん', '2本')
      expect(item.name).toBe('にんじん')
      expect(item.amount).toBe('2本')
      expect(item.checked).toBe(false)

      const list = getShoppingList()
      expect(list).toHaveLength(1)
      expect(list[0].name).toBe('にんじん')
    })

    it('分量なしでアイテムを追加できる', () => {
      const item = addShoppingItem('にんじん')
      expect(item.name).toBe('にんじん')
      expect(item.amount).toBe('')
    })
  })

  describe('toggleShoppingItem', () => {
    it('アイテムのチェック状態を切り替えられる', () => {
      const item = addShoppingItem('にんじん')
      expect(item.checked).toBe(false)

      toggleShoppingItem(item.id)
      const list = getShoppingList()
      expect(list[0].checked).toBe(true)

      toggleShoppingItem(item.id)
      const list2 = getShoppingList()
      expect(list2[0].checked).toBe(false)
    })

    it('存在しないIDでエラーにならない', () => {
      expect(() => toggleShoppingItem('non-existent')).not.toThrow()
    })
  })

  describe('deleteShoppingItem', () => {
    it('アイテムを削除できる', () => {
      const item1 = addShoppingItem('にんじん')
      const item2 = addShoppingItem('たまねぎ')

      expect(getShoppingList()).toHaveLength(2)

      deleteShoppingItem(item1.id)
      const list = getShoppingList()
      expect(list).toHaveLength(1)
      expect(list[0].name).toBe('たまねぎ')
    })
  })

  describe('clearShoppingList', () => {
    it('リストをクリアできる', () => {
      addShoppingItem('にんじん')
      addShoppingItem('たまねぎ')
      expect(getShoppingList()).toHaveLength(2)

      clearShoppingList()
      expect(getShoppingList()).toEqual([])
    })
  })

  describe('saveShoppingList', () => {
    it('リストを保存できる', () => {
      const items: ShoppingItem[] = [
        {
          id: '1',
          name: 'にんじん',
          amount: '2本',
          checked: false,
          created_at: '2024-01-01T00:00:00.000Z',
        },
      ]
      saveShoppingList(items)
      expect(getShoppingList()).toEqual(items)
    })
  })
})
