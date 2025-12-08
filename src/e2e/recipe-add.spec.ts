import { test, expect } from '@playwright/test'

test.describe('レシピ追加ページ', () => {
  test('ページが正しく表示される', async ({ page }) => {
    await page.goto('/recipes/add')

    await expect(page.getByRole('heading', { name: 'レシピを追加' })).toBeVisible()
  })

  test('必須フィールドが存在する', async ({ page }) => {
    await page.goto('/recipes/add')

    // URL入力欄
    const urlInput = page.getByLabel('レシピURL *')
    await expect(urlInput).toBeVisible()
    await expect(urlInput).toHaveAttribute('type', 'url')
    await expect(urlInput).toHaveAttribute('required')

    // タイトル入力欄
    const titleInput = page.getByLabel('タイトル *')
    await expect(titleInput).toBeVisible()
    await expect(titleInput).toHaveAttribute('required')

    // 画像URL入力欄
    const imageUrlInput = page.getByLabel('画像URL *')
    await expect(imageUrlInput).toBeVisible()
    await expect(imageUrlInput).toHaveAttribute('type', 'url')
    await expect(imageUrlInput).toHaveAttribute('required')

    // ソース選択
    const sourceSelect = page.getByLabel('ソース *')
    await expect(sourceSelect).toBeVisible()
  })

  test('オプションフィールドが存在する', async ({ page }) => {
    await page.goto('/recipes/add')

    // メモ入力欄
    const notesTextarea = page.getByLabel('メモ')
    await expect(notesTextarea).toBeVisible()

    // タグ選択
    const tagSelect = page.getByLabel('タグ')
    await expect(tagSelect).toBeVisible()
  })

  test('情報を取得ボタンが存在する', async ({ page }) => {
    await page.goto('/recipes/add')

    const scrapeButton = page.getByRole('button', { name: '情報を取得' })
    await expect(scrapeButton).toBeVisible()
  })

  test('材料追加ボタンが存在する', async ({ page }) => {
    await page.goto('/recipes/add')

    const addIngredientButton = page.getByRole('button', { name: '追加' }).first()
    await expect(addIngredientButton).toBeVisible()
  })

  test('材料を追加できる', async ({ page }) => {
    await page.goto('/recipes/add')

    // 材料追加ボタンをクリック
    await page.getByText('材料').locator('..').getByRole('button', { name: '追加' }).click()

    // 材料入力欄が表示される
    const nameInput = page.getByPlaceholder('名前')
    const amountInput = page.getByPlaceholder('分量')

    await expect(nameInput).toBeVisible()
    await expect(amountInput).toBeVisible()
  })

  test('タグを追加できる', async ({ page }) => {
    await page.goto('/recipes/add')

    // タグを選択
    const tagSelect = page.getByLabel('タグ')
    await tagSelect.selectOption('肉料理')

    // 追加ボタンをクリック
    await page.getByText('タグ').locator('..').getByRole('button', { name: '追加' }).click()

    // タグが表示される
    await expect(page.getByText('肉料理').last()).toBeVisible()
  })

  test('送信ボタンとキャンセルボタンが存在する', async ({ page }) => {
    await page.goto('/recipes/add')

    const submitButton = page.getByRole('button', { name: 'レシピを作成' })
    const cancelButton = page.getByRole('button', { name: 'キャンセル' })

    await expect(submitButton).toBeVisible()
    await expect(cancelButton).toBeVisible()
  })

  test('URLパラメータから初期値が設定される', async ({ page }) => {
    await page.goto('/recipes/add?url=https://cookpad.com/recipe/123&title=テストレシピ')

    const urlInput = page.getByLabel('レシピURL *')
    const titleInput = page.getByLabel('タイトル *')

    await expect(urlInput).toHaveValue('https://cookpad.com/recipe/123')
    await expect(titleInput).toHaveValue('テストレシピ')
  })
})
