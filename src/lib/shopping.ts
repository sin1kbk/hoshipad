import { ShoppingItem } from '@/types/shopping'

const SHOPPING_STORAGE_KEY = 'hoshipad_shopping_list'

export function getShoppingList(): ShoppingItem[] {
  if (typeof window === 'undefined') return []

  try {
    const stored = localStorage.getItem(SHOPPING_STORAGE_KEY)
    if (!stored) return []
    return JSON.parse(stored) as ShoppingItem[]
  } catch {
    return []
  }
}

export function saveShoppingList(items: ShoppingItem[]): void {
  if (typeof window === 'undefined') return

  try {
    localStorage.setItem(SHOPPING_STORAGE_KEY, JSON.stringify(items))
  } catch (error) {
    console.error('Failed to save shopping list:', error)
  }
}

export function addShoppingItem(name: string, amount: string = ''): ShoppingItem {
  const newItem: ShoppingItem = {
    id: crypto.randomUUID(),
    name,
    amount,
    checked: false,
    created_at: new Date().toISOString(),
  }

  const items = getShoppingList()
  items.push(newItem)
  saveShoppingList(items)

  return newItem
}

export function toggleShoppingItem(id: string): void {
  const items = getShoppingList()
  const item = items.find((i) => i.id === id)
  if (item) {
    item.checked = !item.checked
    saveShoppingList(items)
  }
}

export function deleteShoppingItem(id: string): void {
  const items = getShoppingList().filter((i) => i.id !== id)
  saveShoppingList(items)
}

export function clearShoppingList(): void {
  if (typeof window === 'undefined') return

  try {
    localStorage.removeItem(SHOPPING_STORAGE_KEY)
  } catch (error) {
    console.error('Failed to clear shopping list:', error)
  }
}
