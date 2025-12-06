# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**hoshipad** is a personal recipe management application inspired by Cookpad. Users can save recipes from various sources (YouTube, Instagram, Twitter, Cookpad) and manage them in one place. The app is built with Flutter for cross-platform support (iOS, Android, Web) and uses Supabase as the backend.

## Commands

### Development

```bash
# Install dependencies
cd flutter_app
flutter pub get

# Run the app (choose one)
flutter run -d chrome          # Web
flutter run -d ios             # iOS
flutter run -d android         # Android

# Generate code (Freezed models)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Build

```bash
# Build for production
flutter build web                     # Web
flutter build ios --release           # iOS
flutter build apk --release           # Android APK
flutter build appbundle --release     # Android App Bundle
```

### Bookmarklet Deployment

The project includes a bookmarklet feature for saving recipes from web browsers (especially Safari, which doesn't support Web Share Target API). Before deploying:

```bash
# Replace placeholder URL in bookmarklet.html with production URL
cd flutter_app
./scripts/replace_bookmarklet_url.sh https://your-production-url.com
```

## Architecture

### State Management

The app uses **Provider** for state management with the following providers:

- `AuthProvider` - User authentication state
- `RecipeProvider` - Recipe CRUD operations and search
- `ShoppingListProvider` - Shopping list management (local storage)
- `HistoryProvider` - Recipe viewing history (local storage)
- `LikeProvider` - Recipe likes

### Routing

**go_router** is used for declarative routing:

- `/` - Home screen (recipe list)
- `/add` - Add recipe screen (supports query params: `url`, `title`, `image`, `ingredients`)
- `/shopping-list` - Shopping list screen
- `/history` - View history screen
- `/profile` - User profile/kitchen screen
- `/login`, `/signup`, `/reset-password`, `/profile-edit`, `/email-verification` - Auth screens

The main navigation uses a `ShellRoute` with `MainScaffold` for the bottom navigation bar.

### Data Models

Models are defined using **Freezed** and **json_serializable** for immutability and JSON serialization:

- `Recipe` - Main recipe model with `id`, `title`, `url`, `imageUrl`, `notes`, `source`, `tags`, `ingredients`, `likeCount`, etc.
- `InsertRecipe` - DTO for creating/updating recipes (excludes `id` and computed fields)
- `Ingredient` - Recipe ingredient with `name` and `amount`
- `ShoppingItem` - Shopping list item

Enums:
- `RecipeSource` - youtube, instagram, twitter, cookpad
- `RecipeCategory` - 肉料理, 魚介料理, 野菜料理, サラダ, ご飯もの, 麺類, スープ・汁物, お菓子, デザート, パン, お弁当, その他

### Services

- `ApiService` - Supabase REST API wrapper for recipe CRUD operations
- `AuthService` - Supabase Auth wrapper for user authentication
- `CookpadScraperService` - Scrapes recipe metadata from Cookpad URLs (title, image, ingredients)
- `LocalStorageService` - SharedPreferences wrapper for local data persistence

### Supabase Configuration

Supabase credentials are stored in `lib/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

**Note:** These values must be configured before running the app.

### Database Schema

The main table is `recipes` with columns:
- `id` (BIGSERIAL, PK)
- `title` (TEXT)
- `url` (TEXT)
- `image_url` (TEXT)
- `notes` (TEXT, nullable)
- `source` (VARCHAR, check constraint for valid sources)
- `tags` (TEXT[], nullable)
- `user_id` (UUID, nullable)
- `ingredients` (JSONB, nullable)
- `created_at` (TIMESTAMPTZ)

There's also a `recipe_likes` table for tracking user likes (many-to-many relationship).

### Sharing & Deep Linking

The app supports receiving shared URLs in two ways:

1. **Native sharing (iOS/Android)**: Uses `receive_sharing_intent` package to handle shared URLs from other apps
2. **Web bookmarklet**: JavaScript bookmarklet opens the app with query parameters

When a URL is shared, the app navigates to `/add?url=...&title=...` and auto-fills the form.

### Theme & Design

- Uses Material Design 3 with custom theme in `lib/theme/app_theme.dart`
- Primary color: Orange (Cookpad-inspired)
- Google Fonts for typography
- Responsive design with grid/list view toggle
- Platform-specific image loading via conditional imports (`platform_image.dart`)

## Key Patterns

### Conditional Imports for Platform-Specific Code

The app uses Dart's conditional imports to handle platform differences (e.g., `PlatformImage` widget):

```dart
export 'platform_image_stub.dart'
    if (dart.library.io) 'platform_image_io.dart'
    if (dart.library.html) 'platform_image_web.dart';
```

### Recipe Creation with User Context

When creating recipes, `ApiService.createRecipe()` automatically sets `user_id` from the current authenticated user:

```dart
final currentUser = _supabase.auth.currentUser;
final recipeWithUserId = recipe.copyWith(userId: currentUser?.id);
```

### Like System

Recipe likes are fetched via SQL join with `recipe_likes` table and parsed in `_parseRecipesWithLikes()`. The current user's like status is computed on the backend side.

### Cookpad Scraping

When a Cookpad URL is pasted in the add recipe screen, `CookpadScraperService` automatically extracts:
- Recipe title
- Main image URL
- Ingredients list
- Suggested category based on keywords

## Code Generation

The project uses code generation for models. After modifying `*.dart` files with Freezed/JsonSerializable annotations:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Generated files: `*.freezed.dart`, `*.g.dart`

## Design Guidelines

When adding UI components, follow the Cookpad-inspired design:
- **Primary color**: Orange for buttons, accents, active states
- **Background**: White or light gray (#F5F5F5)
- **Text**: Dark gray (#333333) for primary, lighter gray (#666666) for secondary
- **Recipe cards**: Large hero images with 4:3 or 16:9 aspect ratio
- **Buttons**: Rounded corners with slight elevation
