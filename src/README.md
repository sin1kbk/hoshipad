# hoshipad - NextJS版

FlutterアプリをNext.js + TypeScriptで書き直したWebアプリケーションです。

## 技術スタック

- **フレームワーク**: Next.js 16 (App Router)
- **言語**: TypeScript
- **スタイリング**: Tailwind CSS
- **バックエンド**: Supabase (Auth + Database)
- **状態管理**: React Hooks + Zustand (必要に応じて)
- **UI**: lucide-react (アイコン)

## 実装済み機能

### ✅ 完了

1. **認証機能**
   - ログイン (`/auth/login`)
   - サインアップ (`/auth/signup`)
   - メール認証
   - パスワードリセット
   - ログアウト

2. **レシピ管理**
   - レシピ一覧表示 (`/`)
   - レシピ検索・フィルター (ソース別)
   - レシピ追加 (`/recipes/add`)
   - Cookpadスクレイピング機能 (API Route: `/api/scrape`)

3. **UI/UX**
   - レスポンシブデザイン
   - Cookpad風のオレンジを基調としたデザイン
   - グリッドレイアウト
   - ローディング状態
   - エラーハンドリング

### 🚧 未実装（今後の拡張）

以下の機能は基本構造は実装済みですが、完全には実装されていません:

1. **レシピ詳細・編集・削除**
   - レシピ詳細画面 (`/recipes/[id]`)
   - レシピ編集機能
   - レシピ削除機能

2. **いいね機能**
   - いいねボタンのUI実装済み
   - API連携は実装済みだが、リアルタイム更新は要調整

3. **買い物リスト** (`/shopping-list`)
   - ローカルストレージでの管理
   - 材料の追加・削除・チェック

4. **履歴機能** (`/history`)
   - 閲覧したレシピの履歴
   - ローカルストレージでの管理

5. **マイキッチン** (`/profile`)
   - 自分のレシピ一覧
   - プロフィール編集

## セットアップ

### 1. 依存関係のインストール

\`\`\`bash
cd nextjs-app
npm install
\`\`\`

### 2. 環境変数の設定

\`.env.local\`ファイルを作成し、Supabaseの認証情報を設定:

\`\`\`bash
cp .env.local.example .env.local
\`\`\`

\`.env.local\`を編集:

\`\`\`
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url_here
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key_here
\`\`\`

### 3. Supabaseのデータベース設定

Flutter版と同じSupabaseプロジェクトを使用する場合は、すでにテーブルが作成されているはずです。

必要なテーブル:
- \`recipes\` - レシピ情報
- \`recipe_likes\` - いいね情報

### 4. 開発サーバーの起動

\`\`\`bash
npm run dev
\`\`\`

ブラウザで http://localhost:3000 を開いてください。

## ビルド

### 本番ビルド

\`\`\`bash
npm run build
npm run start
\`\`\`

### デプロイ

Vercel、Netlify、Cloudflare Pagesなどにデプロイできます。

**Vercelの場合:**

\`\`\`bash
npm install -g vercel
vercel
\`\`\`

環境変数を設定するのを忘れずに!

## プロジェクト構造

\`\`\`
nextjs-app/
├── app/                      # Next.js App Router
│   ├── api/                  # API Routes
│   │   ├── recipes/          # レシピAPI
│   │   └── scrape/           # Cookpadスクレイピング
│   ├── auth/                 # 認証ページ
│   │   ├── login/
│   │   ├── signup/
│   │   └── ...
│   ├── recipes/              # レシピページ
│   │   ├── add/              # レシピ追加
│   │   └── [id]/             # レシピ詳細
│   ├── globals.css           # グローバルスタイル
│   ├── layout.tsx            # ルートレイアウト
│   └── page.tsx              # ホームページ
├── components/               # Reactコンポーネント
│   ├── layout/               # レイアウト
│   │   └── Header.tsx
│   ├── recipes/              # レシピ関連
│   │   ├── RecipeCard.tsx
│   │   └── RecipeFilters.tsx
│   └── ui/                   # 共通UIコンポーネント
├── lib/                      # ユーティリティ
│   ├── api/                  # API関数
│   │   └── recipes.ts
│   └── supabase/             # Supabase設定
│       ├── client.ts         # クライアント用
│       ├── server.ts         # サーバー用
│       └── middleware.ts     # ミドルウェア用
├── types/                    # TypeScript型定義
│   ├── recipe.ts
│   ├── shopping.ts
│   ├── history.ts
│   └── database.ts
└── middleware.ts             # Next.js Middleware
\`\`\`

## 主な違い (Flutter版との比較)

| 機能 | Flutter版 | Next.js版 |
|------|-----------|-----------|
| 状態管理 | Provider | React Hooks |
| ルーティング | go_router | App Router |
| データ取得 | Dart API | Server Components + API Routes |
| スクレイピング | Dartパッケージ | cheerio (Node.js) |
| ローカルストレージ | shared_preferences | localStorage |
| スタイリング | Material Design 3 | Tailwind CSS |

## テスト

### ユニットテスト

```bash
# すべてのテストを実行
npm test

# ウォッチモードで実行
npm run test:watch

# カバレッジレポート付き
npm test -- --coverage
```

### E2Eテスト

```bash
# Playwrightのインストール（初回のみ）
npx playwright install

# E2Eテストを実行
npm run test:e2e

# UIモードで実行（デバッグに便利）
npm run test:e2e:ui
```

### テスト状況

- ✅ 型定義のテスト: 20テスト成功
- ✅ API関数のテスト: すべて成功
- 🚧 コンポーネントのテスト: 一部要修正
- ✅ E2Eテスト: 構造完成（実行環境要調整）

詳細は [TESTING.md](./TESTING.md) と [TEST_SUMMARY.md](./TEST_SUMMARY.md) を参照してください。

## 開発のヒント

### API Routesの使い方

Server Actionsを使うこともできますが、クライアントサイドから呼び出す場合はAPI Routesを使用しています。

### Supabase SSR

Next.jsでSupabaseを使う場合、SSR対応のため\`@supabase/ssr\`を使用しています:

- **Server Components**: \`lib/supabase/server.ts\`
- **Client Components**: \`lib/supabase/client.ts\`
- **Middleware**: \`middleware.ts\`

### Server Components vs Client Components

- レシピ一覧などのデータ取得はServer Componentsで行う
- インタラクティブな部分 (フィルター、フォームなど) はClient Componentsで行う

## トラブルシューティング

### 認証が機能しない

- \`.env.local\`の環境変数が正しく設定されているか確認
- Supabaseのプロジェクト設定で認証プロバイダーが有効になっているか確認

### スクレイピングが失敗する

- Cookpadのページ構造が変更された可能性があります
- \`app/api/scrape/route.ts\`のセレクタを調整してください

### ビルドエラー

- Node.jsのバージョンを確認 (推奨: v20.9以上、Next.js 16の要件)
- \`npm install\`を再実行してみてください

## 今後の改善点

1. **パフォーマンス最適化**
   - 画像最適化 (next/image)
   - ISR (Incremental Static Regeneration)
   - React Suspenseの活用

2. **テスト**
   - Jest + React Testing Library
   - E2Eテスト (Playwright)

3. **機能追加**
   - レシピ詳細ページの完全実装
   - 買い物リストと履歴機能
   - PWA化
   - オフライン対応

4. **UI改善**
   - アニメーション
   - スケルトンローディング
   - トーストメッセージ

## ライセンス

MIT
