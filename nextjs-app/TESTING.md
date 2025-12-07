# テストガイド

## テストの実行

### ユニットテスト

```bash
# すべてのユニットテストを実行
npm test

# ウォッチモードで実行（開発中に便利）
npm run test:watch

# カバレッジレポート付きで実行
npm test -- --coverage
```

### E2Eテスト

```bash
# Playwrightのインストール（初回のみ）
npx playwright install

# すべてのE2Eテストを実行
npm run test:e2e

# UIモードで実行（デバッグに便利）
npm run test:e2e:ui

# 特定のブラウザのみで実行
npx playwright test --project=chromium
```

## 現在のテスト状況

### ✅ 実装済み

1. **型定義のテスト**
   - `RECIPE_SOURCES`と`RECIPE_CATEGORIES`の検証
   - データ構造の確認

2. **RecipeCardコンポーネントのテスト**
   - レシピ情報の表示
   - いいね機能
   - タグ表示
   - リンク動作

3. **E2Eテスト（基本）**
   - ホームページの表示
   - ナビゲーション
   - 認証ページの表示
   - レシピ追加フォームの存在確認

### 🚧 要修正

1. **RecipeFiltersのテスト**
   - Next.js routerのモックが不完全
   - 実際のルーティング動作のテストが必要

2. **API関数のテスト**
   - Supabaseクライアントのモックが未実装
   - 実際のCRUD操作のテストが必要

## テストの書き方

### コンポーネントのテスト例

\`\`\`typescript
import { render, screen } from '@testing-library/react'
import MyComponent from '@/components/MyComponent'

describe('MyComponent', () => {
  it('正しく表示される', () => {
    render(<MyComponent title="テスト" />)
    expect(screen.getByText('テスト')).toBeInTheDocument()
  })
})
\`\`\`

### E2Eテストの例

\`\`\`typescript
import { test, expect } from '@playwright/test'

test('ホームページが表示される', async ({ page }) => {
  await page.goto('/')
  await expect(page.getByText('hoshipad')).toBeVisible()
})
\`\`\`

## モックの設定

### Next.js Router

`jest.setup.js`で基本的なモックを提供していますが、より詳細なテストが必要な場合は、テストファイル内で上書きできます:

\`\`\`typescript
import { useRouter } from 'next/navigation'

jest.mock('next/navigation', () => ({
  useRouter: jest.fn(),
}))

test('my test', () => {
  const mockPush = jest.fn()
  ;(useRouter as jest.Mock).mockReturnValue({
    push: mockPush,
  })

  // テストコード
})
\`\`\`

### Supabaseクライアント

実際のプロジェクトでは、Supabaseクライアントをモックする必要があります:

\`\`\`typescript
jest.mock('@/lib/supabase/client', () => ({
  createClient: jest.fn(() => ({
    from: jest.fn(() => ({
      select: jest.fn(),
      insert: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    })),
    auth: {
      getUser: jest.fn(),
      signIn: jest.fn(),
      signOut: jest.fn(),
    },
  })),
}))
\`\`\`

## CI/CDでのテスト実行

### GitHub Actions例

\`\`\`yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Run unit tests
        run: npm test

      - name: Install Playwright
        run: npx playwright install --with-deps

      - name: Run E2E tests
        run: npm run test:e2e
        env:
          NEXT_PUBLIC_SUPABASE_URL: \${{ secrets.SUPABASE_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: \${{ secrets.SUPABASE_ANON_KEY }}
\`\`\`

## トラブルシューティング

### テストが失敗する

1. **モックが不完全**
   - エラーメッセージを確認して、どのモジュールが不足しているか確認
   - `jest.setup.js`にモックを追加

2. **環境変数が未設定**
   - `.env.local`ファイルが存在するか確認
   - テスト環境用の環境変数を設定

3. **Playwrightのブラウザが未インストール**
   - `npx playwright install`を実行

### パフォーマンスが遅い

1. **並列実行を有効化**
   - `jest.config.js`で`maxWorkers`を設定
   - Playwrightは自動的に並列実行

2. **不要なテストをスキップ**
   - `test.skip()`や`describe.skip()`を使用

## 参考リンク

- [Jest公式ドキュメント](https://jestjs.io/)
- [React Testing Library](https://testing-library.com/react)
- [Playwright公式ドキュメント](https://playwright.dev/)
- [Next.js Testing Guide](https://nextjs.org/docs/testing)
