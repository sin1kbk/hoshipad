const HISTORY_STORAGE_KEY = 'hoshipad_history'
const MAX_HISTORY_ITEMS = 50

export interface HistoryItem {
  recipe_id: number
  viewed_at: string
}

export function getHistory(): HistoryItem[] {
  if (typeof window === 'undefined') return []

  try {
    const stored = localStorage.getItem(HISTORY_STORAGE_KEY)
    if (!stored) return []
    return JSON.parse(stored) as HistoryItem[]
  } catch {
    return []
  }
}

export function addToHistory(recipeId: number): void {
  if (typeof window === 'undefined') return

  try {
    const history = getHistory()
    // 既存のエントリを削除（重複を避ける）
    const filtered = history.filter((item) => item.recipe_id !== recipeId)
    // 新しいエントリを先頭に追加
    const newHistory: HistoryItem[] = [
      { recipe_id: recipeId, viewed_at: new Date().toISOString() },
      ...filtered,
    ].slice(0, MAX_HISTORY_ITEMS)

    localStorage.setItem(HISTORY_STORAGE_KEY, JSON.stringify(newHistory))
  } catch (error) {
    console.error('Failed to save history:', error)
  }
}

export function clearHistory(): void {
  if (typeof window === 'undefined') return

  try {
    localStorage.removeItem(HISTORY_STORAGE_KEY)
  } catch (error) {
    console.error('Failed to clear history:', error)
  }
}

export function getHistoryRecipeIds(): number[] {
  return getHistory().map((item) => item.recipe_id)
}
