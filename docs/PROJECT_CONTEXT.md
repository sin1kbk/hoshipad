# PROJECT_CONTEXT.md

## 1. Project Overview

- **Purpose**: 個人用レシピ管理アプリケーション (Cookpad inspired)。YouTube, Instagram, Twitter, Cookpad など様々なソースからレシピを保存・管理します。
- **Status**: Flutter アプリからの移行プロジェクト (Next.js 版)。
- **Tech Stack**:
  - **Frontend**: Next.js 15 (App Router), TypeScript, React 18
  - **Styling**: Tailwind CSS, Lucide React (Icons)
  - **Backend**: Supabase (Auth, Database, Storage)
  - **State Management**: React Hooks + Zustand
  - **Testing**: Jest, Playwright

## 2. Commands

開発に必要な主なコマンド (`src/package.json` より):

### Development
```bash
cd src
npm run dev          # 開発サーバー起動 (localhost:3000)
npm run lint         # Lint チェック
```

### Build
```bash
cd src
npm run build        # 本番ビルド
npm run start        # ビルド後の実行
```

### Test
```bash
cd src
npm run test         # Jest (Unit Tests)
npm run test:e2e     # Playwright (E2E Tests)
```

## 3. Architecture

### Directory Structure
- `src/app`: Next.js App Router のルート。
  - `api/`: API Routes (例: `recipes`, `scrape`)。
  - `auth/`: 認証関連ページ (`login`, `signup`)。
  - `recipes/`: レシピ詳細・編集ページ。
- `src/components`: React コンポーネント。
  - `ui/`: 汎用 UI コンポーネント。
- `src/lib`: ユーティリティ、Supabase クライアント設定 (`supabase/`)。
- `src/types`: TypeScript 型定義 (`recipe.ts`, `database.ts` 等)。

### State Management
- 主に React Hooks (`useState`, `useEffect`) と Server Components によるデータフェッチを利用。
- グローバルな状態管理には `zustand` が依存関係に含まれているが、基本的には Server Actions / API Routes との連携が主。

### Routing
- **App Router** を使用。
- `/`: ホーム (レシピ一覧)
- `/auth/*`: 認証 (Login, Signup, Verify)
- `/recipes/add`: レシピ追加
- `/recipes/[id]`: レシピ詳細

### Database Schema (Supabase)
主要テーブル (`src/types/recipe.ts` および `src/README.md` より推測):
- **recipes**:
  - `id` (number)
  - `title`, `url`, `image_url`
  - `source` (enum: youtube, instagram, twitter, cookpad)
  - `ingredients` (jsonb array)
  - `user_id` (uuid)
- **recipe_likes**: ユーザーのいいね情報

## 4. Key Patterns & Rules

- **API Integration**: クライアントサイドからのデータ操作は `src/app/api` 配下の API Routes を経由、または Server Components で直接データ取得。
- **Scraping**: `cheerio` を使用した Cookpad スクレイピング機能が `src/app/api/scrape` に実装されている。
- **Supabase**: `@supabase/ssr` を使用し、Server/Client Components 両方で認証状態を扱えるように構成 (`src/lib/supabase`).

## 5. Design Guidelines

- **Theme**: Cookpad 風のオレンジを基調としたデザイン。
- **Styling**: Tailwind CSS を全面的に使用。
- **Responsive**: グリッドレイアウトを採用し、モバイル/デスクトップに対応。
