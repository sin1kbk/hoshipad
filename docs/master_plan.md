# Master Plan

## 1. Project Overview

**Hoshipad** (Hoshipad Next.js) is a personal recipe management application inspired by Cookpad. It aggregates and manages recipes from various sources (YouTube, Instagram, Twitter, Cookpad) into a single, unified interface.

### Status
- **Phase**: Next.js Migration (Active)
- **Current State**: Core functionalities (Auth, Recipe CRUD, Scraping, Shopping List) are implemented.
- **Next Steps**: Refinement of UI/UX, Performance optimization, and Feature stabilization.

## 2. Architecture

### Technology Stack
- **Frontend**: Next.js 15 (App Router), React 18, TypeScript, Tailwind CSS
- **Backend / BaaS**: Supabase (Auth, PostgreSQL Database, Storage)
- **State Management**: Zustand + React Hooks
- **Testing**: Jest (Unit), Playwright (E2E)

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

## 4. Directory Structure Strategy

- `src/app`: Routes & Page Logic (Server Components where possible).
- `src/components`: Reusable UI (Client Components).
- `src/lib`: Core logic (Supabase client, Utils).
- `docs`: Specification & Planning (Single Source of Truth).
