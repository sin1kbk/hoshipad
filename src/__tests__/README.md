# テストについて

このプロジェクトにはユニットテストとE2Eテストが含まれています。

## ユニットテスト (Jest + React Testing Library)

### 実行方法

```bash
# すべてのテストを実行
npm test

# ウォッチモードで実行
npm run test:watch
```

### テストファイル

- `__tests__/components/recipes/RecipeCard.test.tsx` - RecipeCardコンポーネントのテスト
- `__tests__/components/recipes/RecipeFilters.test.tsx` - RecipeFiltersコンポーネントのテスト (要修正)
- `__tests__/types/recipe.test.ts` - 型定義のテスト
- `__tests__/lib/api/recipes.test.ts` - API関数のテスト

### 注意点

一部のテストはモックの設定が不完全なため、失敗することがあります。実際のプロジェクトでは以下を実装してください:

1. **Supabaseクライアントのモック**
   - `lib/supabase/client.ts`と`lib/supabase/server.ts`のモック
   - テストごとに適切なレスポンスを返すように設定

2. **Next.js Routerのモック**
   - `jest.setup.js`で基本的なモックは実装済み
   - より詳細な動作が必要な場合は追加実装

3. **画像コンポーネントのモック**
   - `next/image`のモックが必要な場合があります

## E2Eテスト (Playwright)

### セットアップ

```bash
# Playwrightブラウザのインストール
npx playwright install
```

### 実行方法

```bash
# すべてのE2Eテストを実行
npm run test:e2e

# UIモードで実行 (インタラクティブ)
npm run test:e2e:ui
```

### テストファイル

- `e2e/home.spec.ts` - ホームページのテスト
- `e2e/auth.spec.ts` - 認証フローのテスト
- `e2e/recipe-add.spec.ts` - レシピ追加ページのテスト

### 注意点

E2Eテストを実行する前に:

1. `.env.local`ファイルに環境変数を設定
2. 開発サーバーが自動的に起動されます（`playwright.config.ts`で設定）
3. Supabaseプロジェクトが正しく設定されている必要があります

## テスト戦略

### ユニットテスト
- コンポーネントの表示ロジック
- ユーザーインタラクション
- 型定義とバリデーション
- ユーティリティ関数

### E2Eテスト
- ページナビゲーション
- フォーム送信
- 認証フロー
- ユーザージャーニー全体

## 今後の改善

1. **テストカバレッジの向上**
   - Server Componentsのテスト
   - API Routesのテスト
   - エラーハンドリングのテスト

2. **モックの改善**
   - Supabaseクライアントの完全なモック
   - 外部APIのモック

3. **ビジュアルリグレッションテスト**
   - Playwrightのスクリーンショット機能を活用

4. **パフォーマンステスト**
   - Lighthouse CIの導入
