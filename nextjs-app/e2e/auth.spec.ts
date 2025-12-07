import { test, expect } from '@playwright/test'

test.describe('認証フロー', () => {
  test('ログインページが表示される', async ({ page }) => {
    await page.goto('/auth/login')

    await expect(page.getByRole('heading', { name: 'ログイン' })).toBeVisible()
    await expect(page.getByText('hoshipadへようこそ')).toBeVisible()
  })

  test('ログインフォームが存在する', async ({ page }) => {
    await page.goto('/auth/login')

    // メールアドレス入力欄
    const emailInput = page.getByLabel('メールアドレス')
    await expect(emailInput).toBeVisible()
    await expect(emailInput).toHaveAttribute('type', 'email')

    // パスワード入力欄
    const passwordInput = page.getByLabel('パスワード')
    await expect(passwordInput).toBeVisible()
    await expect(passwordInput).toHaveAttribute('type', 'password')

    // ログインボタン
    const loginButton = page.getByRole('button', { name: 'ログイン' })
    await expect(loginButton).toBeVisible()
  })

  test('サインアップページへのリンクがある', async ({ page }) => {
    await page.goto('/auth/login')

    const signupLink = page.getByRole('link', { name: '新規登録' })
    await expect(signupLink).toBeVisible()
    await expect(signupLink).toHaveAttribute('href', '/auth/signup')
  })

  test('パスワードリセットページへのリンクがある', async ({ page }) => {
    await page.goto('/auth/login')

    const resetLink = page.getByRole('link', { name: 'パスワードを忘れた場合' })
    await expect(resetLink).toBeVisible()
    await expect(resetLink).toHaveAttribute('href', '/auth/reset-password')
  })

  test('サインアップページが表示される', async ({ page }) => {
    await page.goto('/auth/signup')

    await expect(page.getByRole('heading', { name: '新規登録' })).toBeVisible()
    await expect(page.getByText('hoshipadでレシピを管理しましょう')).toBeVisible()
  })

  test('サインアップフォームが存在する', async ({ page }) => {
    await page.goto('/auth/signup')

    // メールアドレス入力欄
    const emailInput = page.getByLabel('メールアドレス')
    await expect(emailInput).toBeVisible()

    // パスワード入力欄
    const passwordInput = page.getByLabel('パスワード')
    await expect(passwordInput).toBeVisible()
    await expect(passwordInput).toHaveAttribute('minlength', '6')

    // 登録ボタン
    const signupButton = page.getByRole('button', { name: '登録' })
    await expect(signupButton).toBeVisible()
  })

  test('ログインページへのリンクがある', async ({ page }) => {
    await page.goto('/auth/signup')

    const loginLink = page.getByRole('link', { name: 'ログイン' })
    await expect(loginLink).toBeVisible()
    await expect(loginLink).toHaveAttribute('href', '/auth/login')
  })
})
