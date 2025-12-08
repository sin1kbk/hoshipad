# Recipe Management Specification

## 1. Overview
Core functionality to Create, Read, Update, Delete (CRUD) recipes, including importing from external URLs.

## 2. Data Model
Based on `Recipe` type (`src/types/recipe.ts`).

- **Sources**: YouTube, Instagram, Twitter, Cookpad.
- **Categories**: 肉料理, 魚介料理, etc. (Fixed list).
- **Ingredients**: JSON structure `[{ name, amount }]`.

## 3. Features

### 3.1 Recipe List (Home)
- **Route**: `/`
- **Display**: Grid of recipe cards (Image + Title).
- **Filter**: (Planned) By category or source.
- **Search**: (Planned) By title.

### 3.2 Recipe Details
- **Route**: `/recipes/[id]`
- **Content**:
  - Image, Title, Source Icon.
  - External Link button.
  - Ingredients list.
  - Notes.
  - Edit key / Delete key.

### 3.3 Add Recipe
- **Route**: `/recipes/add`
- **Modes**:
  - **Manual Entry**: User fills all fields.
  - **Import (Scrape)**:
    - User pastes URL (e.g., Cookpad).
    - API `/api/scrape` fetches Title, Image, Ingredients.
    - Form auto-fills.
- **iOS Share Integration**: Accepts `?url=...` query param to auto-start import.

### 3.4 Edit Recipe
- **Route**: `/recipes/[id]/edit` (or modal).
- **Function**: Update fields.

### 3.5 Web Scraping
- **Endpoint**: `/api/scrape`
- **Supported Sites**: Cookpad.
- **Logic**: Extracts LD-JSON or metadata for Title, Image, Ingredients.

## 3.6 History
- Tracks last viewed recipes locally or in DB (see `history` type).
