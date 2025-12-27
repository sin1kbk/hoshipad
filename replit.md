# Hoshipad - Recipe Management App

## Overview
Hoshipad is a Next.js recipe management application with Supabase backend for authentication and data storage. The app allows users to save, browse, and manage recipes from various sources including YouTube, Instagram, Twitter, and Cookpad.

## Project Structure
```
src/
├── app/                    # Next.js App Router pages
│   ├── api/               # API routes
│   │   ├── profile/       # User profile endpoints
│   │   ├── recipes/       # Recipe CRUD endpoints
│   │   └── scrape/        # Recipe scraping endpoint
│   ├── auth/              # Authentication pages
│   ├── history/           # Viewing history page
│   ├── profile/           # User profile pages
│   ├── recipes/           # Recipe pages
│   └── shopping-list/     # Shopping list page
├── components/            # Reusable React components
│   ├── layout/           # Layout components (Header, Nav)
│   └── recipes/          # Recipe-specific components
├── lib/                   # Utility libraries
│   ├── api/              # API client functions
│   └── supabase/         # Supabase client configuration
├── types/                 # TypeScript type definitions
└── e2e/                   # End-to-end tests (Playwright)
```

## Tech Stack
- **Framework**: Next.js 16 with App Router
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **Database/Auth**: Supabase
- **State Management**: Zustand
- **Icons**: Lucide React
- **Testing**: Jest, Playwright

## Environment Variables
Required secrets:
- `NEXT_PUBLIC_SUPABASE_URL` - Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Supabase anonymous key

## Development
The development server runs on port 5000:
```bash
cd src && npm run dev -- -p 5000 -H 0.0.0.0
```

## Key Features
- Recipe browsing with category filters
- Recipe saving from multiple sources
- User authentication via Supabase
- Shopping list management
- Viewing history tracking
- Profile management
