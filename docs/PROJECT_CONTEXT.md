# Master Plan

## 1. Project Overview

**Hoshipad** (Hoshipad Next.js) is a personal recipe management application inspired by Cookpad. It aggregates and manages recipes from various sources (YouTube, Instagram, Twitter, Cookpad) into a single, unified interface.

### Status
- **Phase**: Next.js Migration (Active)
- **Current State**: Core functionalities (Auth, Recipe CRUD, Scraping, Shopping List) are implemented.
- **Next Steps**: Refinement of UI/UX, Performance optimization, and Feature stabilization.

## 2. Architecture

### Technology Stack
- **Frontend**: Next.js 16 (App Router), React 19, TypeScript, Tailwind CSS
- **Backend / BaaS**: Supabase (Auth, PostgreSQL Database, Storage)
- **State Management**: Zustand + React Hooks
- **Testing**: Jest (Unit), Playwright (E2E)
- **Styling**: Tailwind CSS, Lucide React (Icons)
- **Runtime**: Node.js v20.9+ (Next.js 16の要件)
- **Linting**: ESLint 9+ (Next.js 16の要件)

### Directory Structure Strategy
- `src/app`: Next.js App Router root.
  - `api/`: API Routes (e.g., `recipes`, `scrape`).
  - `auth/`: Authentication pages (`login`, `signup`).
  - `recipes/`: Recipe detail and edit pages.
- `src/components`: React Components.
  - `ui/`: Generic UI components.
- `src/lib`: Core logic, Utilities, Supabase client configuration (`supabase/`).
- `src/types`: TypeScript definitions (`recipe.ts`, `database.ts`, etc).
- `docs`: Specification & Planning (Single Source of Truth).

### Data Architecture (Supabase)

#### Recipes (`recipes`)
- **Core Entity**: `id`, `title`, `url`, `image_url`, `notes`, `source`, `tags`.
- **Ingredients**: Stored as JSONB (`ingredients`: `[{ name, amount }]`).
- **Ownership**: `user_id` (UUID) links to Supabase Auth.
- **Likes**: `like_count` (counter cache), `recipe_likes` table for user-recipe relation.

#### History (`history`)
- Tracks viewed recipes (`recipe_id`, `viewed_at`).

#### Shopping List (`shopping_items` inferred)
- Simple items with `name`, `amount`, `checked` status.

## 3. Key Workflows

### Authentication
- Supabase Auth integration (Email/Password).
- Middleware protection for `/recipes/*` and authenticated routes.

### Recipe Management
- **Creation**: Manually or via Scraping (Cookpad key support).
- **Viewing**: Detail view with external link support.
- **Sharing**: iOS Shortcut integration for easy import from mobile share sheets.

### Scraping
- **Engine**: Cheerio based scraper API (`/api/scrape`).
- **Target**: Cookpad (primary), potentially others.

## 4. Development Commands

### Development
```bash
cd src
npm run dev          # Start dev server (localhost:3000)
npm run lint         # Run lint check
```

### Build
```bash
cd src
npm run build        # Production build
npm run start        # Start production server
```

### Test
```bash
cd src
npm run test         # Jest (Unit Tests)
npm run test:e2e     # Playwright (E2E Tests)
```

## 5. Design Guidelines

- **Theme**: Cookpad 風のオレンジを基調としたデザイン。
- **Styling**: Tailwind CSS を全面的に使用。
- **Responsive**: グリッドレイアウトを採用し、モバイル/デスクトップに対応。
