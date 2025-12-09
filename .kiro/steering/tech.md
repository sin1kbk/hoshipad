# Technology Stack

## Core Technologies

- **Framework**: Next.js 15 (App Router)
- **Language**: TypeScript (strict mode enabled)
- **Runtime**: Node.js v20+
- **Styling**: Tailwind CSS
- **Icons**: lucide-react
- **Backend**: Supabase (Auth + PostgreSQL + Storage)
- **State Management**: React Hooks + Zustand
- **Web Scraping**: cheerio

## Testing

- **Unit Tests**: Jest + React Testing Library
- **E2E Tests**: Playwright

## Common Commands

```bash
# Development
npm run dev          # Start dev server at localhost:3000
npm run lint         # Run ESLint

# Build
npm run build        # Production build
npm run start        # Start production server

# Testing
npm test             # Run Jest unit tests
npm run test:watch   # Jest in watch mode
npm run test:e2e     # Run Playwright E2E tests
npm run test:e2e:ui  # Playwright UI mode
```

## Key Dependencies

- `@supabase/ssr` - Supabase SSR support for Next.js
- `@supabase/supabase-js` - Supabase client
- `cheerio` - HTML parsing for web scraping
- `zustand` - Lightweight state management

## Path Aliases

- `@/*` maps to `src/*` (configured in tsconfig.json)

## Environment Variables

Required in `.env.local`:
- `NEXT_PUBLIC_SUPABASE_URL` - Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Supabase anonymous key
