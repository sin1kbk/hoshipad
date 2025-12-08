export interface ShoppingItem {
  id: string
  name: string
  amount: string
  checked: boolean
  created_at: string
}

export interface CreateShoppingItem {
  name: string
  amount: string
}
