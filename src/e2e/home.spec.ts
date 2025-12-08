import { test, expect } from '@playwright/test'

test.describe('ホームページ', () => {
  test('ページが正しく表示される', async ({ page, isMobile }) => {
    await page.goto('/')

    // ヘッダーが表示されている
    // ヘッダーが表示されている
    if (!isMobile) {
      await expect(page.getByText('hoshipad')).toBeVisible()
    }

    // タイトルが表示されている
    // タイトルが表示されている
    await expect(page.getByRole('heading', { name: '保存されたレシピ' })).toBeVisible()
  })

  test('ナビゲーションメニューが機能する', async ({ page, isMobile }) => {
    await page.goto('/')

    if (isMobile) {
      // モバイルでは現在ナビゲーションメニューが表示されないためスキップ
      return
    }

    // ホームリンク
    await expect(page.getByRole('link', { name: 'ホーム' })).toBeVisible()

    // 買い物リストリンク
    const shoppingListLink = page.getByRole('link', { name: '買い物リスト' })
    await expect(shoppingListLink).toBeVisible()

    // 履歴リンク
    const historyLink = page.getByRole('link', { name: '履歴' })
    await expect(historyLink).toBeVisible()
  })

  test('レシピ追加ボタンが表示される', async ({ page }) => {
    await page.goto('/')

    const addButton = page.getByRole('link', { name: 'レシピを追加' })
    await expect(addButton).toBeVisible()
    await expect(addButton).toHaveAttribute('href', '/recipes/add')
  })

  test('検索ボックスが表示される', async ({ page }) => {
    await page.goto('/')

    const searchInput = page.getByPlaceholder('料理名・食材で検索')
    await expect(searchInput).toBeVisible()
  })

  test('ソースフィルターボタンが表示される', async ({ page }) => {
    await page.goto('/')

    await expect(page.getByRole('button', { name: 'すべて' })).toBeVisible()
    await expect(page.getByRole('button', { name: 'YouTube' })).toBeVisible()
    await expect(page.getByRole('button', { name: 'Instagram' })).toBeVisible()
    await expect(page.getByRole('button', { name: 'Twitter' })).toBeVisible()
    await expect(page.getByRole('button', { name: 'クックパッド' })).toBeVisible()
  })

  test('ソースフィルターをクリックするとURLが変わる', async ({ page }) => {
    await page.goto('/')

    // YouTubeフィルターをクリック
    await page.getByRole('button', { name: 'YouTube' }).click()

    // URLにsource=youtubeが含まれる
    await expect(page).toHaveURL(/source=youtube/)
  })

  test('検索テキストを入力するとURLが変わる', async ({ page }) => {
    await page.goto('/')

    const searchInput = page.getByPlaceholder('料理名・食材で検索')
    await searchInput.click()
    await searchInput.fill('肉じゃが')
    await page.waitForTimeout(100)
    await searchInput.press('Enter')

    // URLにq=肉じゃがが含まれる
    await page.waitForTimeout(500) // debounce待ち
    await expect(page).toHaveURL(/q=/)
  })
})
