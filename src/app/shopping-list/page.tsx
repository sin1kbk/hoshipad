'use client'

import { useState, useEffect } from 'react'
import HeaderClient from '@/components/layout/HeaderClient'
import BottomNav from '@/components/layout/BottomNav'
import {
  getShoppingList,
  addShoppingItem,
  toggleShoppingItem,
  deleteShoppingItem,
  clearShoppingList,
} from '@/lib/shopping'
import { ShoppingItem } from '@/types/shopping'
import { Plus, Trash2 } from 'lucide-react'

export default function ShoppingListPage() {
  const [items, setItems] = useState<ShoppingItem[]>([])
  const [nameInput, setNameInput] = useState('')
  const [amountInput, setAmountInput] = useState('')

  useEffect(() => {
    loadItems()
  }, [])

  const loadItems = () => {
    setItems(getShoppingList())
  }

  const handleAddItem = () => {
    const name = nameInput.trim()
    if (!name) return

    addShoppingItem(name, amountInput.trim())
    setNameInput('')
    setAmountInput('')
    loadItems()
  }

  const handleToggle = (id: string) => {
    toggleShoppingItem(id)
    loadItems()
  }

  const handleDelete = (id: string) => {
    deleteShoppingItem(id)
    loadItems()
  }

  const handleClear = () => {
    if (confirm('買い物リストをすべて削除しますか？')) {
      clearShoppingList()
      loadItems()
    }
  }

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      handleAddItem()
    }
  }

  const checkedCount = items.filter((item) => item.checked).length
  const uncheckedItems = items.filter((item) => !item.checked)
  const checkedItems = items.filter((item) => item.checked)

  return (
    <>
      <HeaderClient initialUser={null} />
      <main className="container mx-auto px-3 py-6 pb-24 sm:px-4 md:pb-8 max-w-2xl">
        <div className="mb-6 flex items-center justify-between">
          <h1 className="text-2xl font-bold text-gray-900">買い物リスト</h1>
          {items.length > 0 && (
            <button
              onClick={handleClear}
              className="text-sm text-gray-600 hover:text-gray-900"
            >
              すべて削除
            </button>
          )}
        </div>

        {/* 追加フォーム */}
        <div className="mb-6 flex gap-2">
          <div className="flex-1 space-y-2">
            <input
              type="text"
              value={nameInput}
              onChange={(e) => setNameInput(e.target.value)}
              onKeyPress={handleKeyPress}
              placeholder="買うものを入力..."
              className="w-full rounded-lg border border-gray-300 px-3 py-2 focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary"
            />
            <input
              type="text"
              value={amountInput}
              onChange={(e) => setAmountInput(e.target.value)}
              onKeyPress={handleKeyPress}
              placeholder="分量（任意）"
              className="w-full rounded-lg border border-gray-300 px-3 py-2 focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary"
            />
          </div>
          <button
            onClick={handleAddItem}
            className="flex items-center justify-center h-10 w-10 rounded-lg bg-primary text-white hover:bg-primary/90 transition-colors shrink-0"
          >
            <Plus className="h-5 w-5" />
          </button>
        </div>

        {/* リスト */}
        {items.length === 0 ? (
          <div className="py-12 text-center">
            <p className="text-gray-500">買い物リストは空です</p>
          </div>
        ) : (
          <div className="space-y-4">
            {/* 未チェックのアイテム */}
            {uncheckedItems.length > 0 && (
              <div>
                <h2 className="text-sm font-medium text-gray-700 mb-2">
                  未チェック ({uncheckedItems.length})
                </h2>
                <div className="space-y-2">
                  {uncheckedItems.map((item) => (
                    <div
                      key={item.id}
                      className="flex items-center gap-3 p-3 bg-white rounded-lg border border-gray-200 hover:border-primary transition-colors"
                    >
                      <input
                        type="checkbox"
                        checked={item.checked}
                        onChange={() => handleToggle(item.id)}
                        className="h-5 w-5 text-primary rounded border-gray-300 focus:ring-primary"
                      />
                      <div className="flex-1">
                        <div className="text-gray-900">{item.name}</div>
                        {item.amount && (
                          <div className="text-sm text-gray-500">{item.amount}</div>
                        )}
                      </div>
                      <button
                        onClick={() => handleDelete(item.id)}
                        className="p-1 text-gray-400 hover:text-red-500 transition-colors"
                      >
                        <Trash2 className="h-5 w-5" />
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* チェック済みのアイテム */}
            {checkedItems.length > 0 && (
              <div>
                <h2 className="text-sm font-medium text-gray-700 mb-2">
                  チェック済み ({checkedCount})
                </h2>
                <div className="space-y-2">
                  {checkedItems.map((item) => (
                    <div
                      key={item.id}
                      className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg border border-gray-200 opacity-75"
                    >
                      <input
                        type="checkbox"
                        checked={item.checked}
                        onChange={() => handleToggle(item.id)}
                        className="h-5 w-5 text-primary rounded border-gray-300 focus:ring-primary"
                      />
                      <div className="flex-1">
                        <div className="text-gray-500 line-through">{item.name}</div>
                        {item.amount && (
                          <div className="text-sm text-gray-400 line-through">
                            {item.amount}
                          </div>
                        )}
                      </div>
                      <button
                        onClick={() => handleDelete(item.id)}
                        className="p-1 text-gray-400 hover:text-red-500 transition-colors"
                      >
                        <Trash2 className="h-5 w-5" />
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}
      </main>
      <BottomNav />
    </>
  )
}
