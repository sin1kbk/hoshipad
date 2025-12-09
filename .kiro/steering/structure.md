# Project Structure

All source code lives in the `src/` directory.

## Directory Organization

```
src/
├── app/                    # Next.js App Router
│   ├── api/               # API Routes
│   │   ├── recipes/       # Recipe CRUD endpoints
│   │   ├── scrape/        # Cookpad scraping endpoint
│   │   └── profile/       # User profile endpoint
│   ├── auth/              # Authentication pages
│   │   ├── login/
│   │   ├── signup/
│   │   ├── callback/      # OAuth callback
│   │   └── verify-email/
│   ├── recipes/           # Recipe pages
│   │   ├── [id]/          # Recipe detail & edit
│   │   └── add/           # Add new recipe
│   ├── shopping-list/     # Shopping list page
│   ├── history/           # Recipe history page
│   ├── profile/           # User profile pages
│   ├── layout.tsx         # Root layout
│   ├── page.tsx           # Home page (recipe list)
│   └── globals.css        # Global styles
├── components/            # React components
│   ├── layout/            # Layout components (Header, etc)
│   ├── recipes/           # Recipe-specific components
│   └── ui/                # Reusable UI components
├── lib/                   # Core utilities
│   ├── api/               # API functions (recipes.ts)
│   ├── supabase/          # Supabase client configs
│   │   ├── client.ts      # Client-side Supabase
│   │   ├── server.ts      # Server-side Supabase
│   │   └── middleware.ts  # Middleware Supabase
│   ├── history.ts         # History management
│   └── shopping.ts        # Shopping list logic
├── types/                 # TypeScript type definitions
│   ├── recipe.ts          # Recipe types & constants
│   ├── database.ts        # Supabase database types
│   ├── history.ts         # History types
│   └── shopping.ts        # Shopping list types
├── __tests__/             # Test files (mirrors src structure)
├── e2e/                   # Playwright E2E tests
└── middleware.ts          # Next.js middleware (auth)
```

## Key Conventions

### Components
- **Client Components**: Use `'use client'` directive at top of file
- **Server Components**: Default for app/ directory, no directive needed
- **Naming**: PascalCase for component files (e.g., `RecipeCard.tsx`)

### API Routes
- Located in `app/api/`
- Export `GET`, `POST`, `PUT`, `DELETE` functions
- Use `NextRequest` and `NextResponse` types
- Always check authentication for protected endpoints

### Supabase Usage
- **Server Components/API Routes**: Import from `@/lib/supabase/server`
- **Client Components**: Import from `@/lib/supabase/client`
- **Middleware**: Import from `@/lib/supabase/middleware`

### Types
- Define all types in `types/` directory
- Export constants alongside types (e.g., `RECIPE_SOURCES`)
- Use TypeScript strict mode

### Styling
- Tailwind CSS utility classes only
- Responsive design with mobile-first approach
- Primary color: Orange (Cookpad-inspired)
- Use `lucide-react` for icons

### Testing
- Unit tests in `__tests__/` mirror source structure
- E2E tests in `e2e/` directory
- Test files use `.test.ts` or `.test.tsx` extension
