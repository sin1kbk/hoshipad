# hoshipad Project Rules

## 1. Project Overview
**hoshipad** is a personal recipe management application designed to organize recipes from various sources (YouTube, Instagram, Twitter, Cookpad, etc.).

## 2. Technology Stack
- **Frontend**: Flutter (Mobile/Web)
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **State Management**: Provider
- **Routing**: GoRouter
- **UI Framework**: Material Design 3

## 3. Database Schema
### `recipes` Table
| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | BIGSERIAL | PK | Unique ID |
| `title` | TEXT | NOT NULL | Recipe Title |
| `url` | TEXT | NOT NULL | Original URL |
| `image_url` | TEXT | NOT NULL | Image URL |
| `notes` | TEXT | | User Notes |
| `source` | VARCHAR(20) | CHECK (...) | Source (youtube, instagram, etc.) |
| `category` | VARCHAR(30) | CHECK (...) | Category (Meat, Fish, etc.) |
| `created_at` | TIMESTAMPTZ | DEFAULT NOW() | Creation Time |

## 4. Current Features (Implemented)
- [x] **Home Screen**: List/Grid view of recipes.
- [x] **Add Recipe**: Form to input new recipe details.
- [x] **Delete Recipe**: Ability to remove recipes.
- [x] **Search & Filter**: Filter by category and search by title.
- [x] **Supabase Integration**: Basic connection and data fetching.

## 5. Missing Features (To Be Implemented)
- [ ] **Edit Recipe**: Ability to update existing recipes.
- [ ] **Image Upload**: Upload images to Supabase Storage (currently using URLs).
- [ ] **Recipe Detail View**: A dedicated screen to view full recipe details (currently opens URL directly?).
- [ ] **Authentication**: (Optional) User login/signup.

## 6. Design Guidelines (Cookpad-inspired)
- **Color Palette**:
    - **Primary**: Orange (`#FF7400` or similar warm orange) - Used for primary buttons, accents, and active states.
    - **Background**: White (`#FFFFFF`) or very light gray (`#F5F5F5`) for content areas.
    - **Text**: Dark Gray (`#333333`) for primary text, Lighter Gray (`#666666`) for secondary text.
- **Typography**: Clean, sans-serif fonts (System default is fine, but styled for readability).
- **Navigation**:
    - Bottom Navigation Bar for main sections (Home, Search, Add, Profile).
    - Floating Action Button (FAB) or prominent center button for "Add Recipe".
- **Components**:
    - **Recipe Card**: Large hero image (aspect ratio ~4:3 or 16:9), clear title, author info, and heart/like count.
    - **Buttons**: Rounded corners, flat design with slight elevation for primary actions.
    - **Inputs**: Clean text fields with clear labels and placeholders.
