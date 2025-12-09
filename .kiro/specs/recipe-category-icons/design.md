# Design Document

## Overview

「カテゴリーから探す」欄（CategoryFilterコンポーネント）に表示される各料理種別に対して、適切なアイコンを使い分ける機能を実装します。現在、全てのカテゴリーが同じ`Utensils`アイコンを使用していますが、各カテゴリーに固有のアイコンを割り当てることで、ユーザーが視覚的にカテゴリーを識別しやすくします。

実装には以下が含まれます：

1. カテゴリーとアイコンのマッピング定義の更新
2. CategoryFilterコンポーネントでの適切なアイコンのインポートと使用
3. 各カテゴリーに適したlucide-reactアイコンの選択

## Architecture

この機能は既存のCategoryFilterコンポーネントの改善であり、以下の変更が必要です：

### Presentation Layer
- `CategoryFilter`コンポーネント内の`categoryIcons`マッピングを更新
- 各カテゴリーに適したlucide-reactアイコンをインポート
- 既存のUI構造とスタイリングは維持

### Icon Library
- lucide-reactライブラリを使用（既にプロジェクトで使用中）
- 各カテゴリーに適したアイコンを選択し、インポート

## Components and Interfaces

### Updated CategoryFilter Component

CategoryFilterコンポーネント内の`categoryIcons`マッピングを更新：

```typescript
// Before (現在の実装)
const categoryIcons: Record<string, any> = {
  '肉料理': Utensils,
  '魚介料理': Utensils,
  '野菜料理': Utensils,
  // ... 全て同じUtensils
}

// After (更新後)
const categoryIcons: Record<string, any> = {
  '肉料理': Beef,
  '魚介料理': Fish,
  '野菜料理': Carrot,
  'サラダ': Salad,
  'ご飯もの': Bowl,
  '麺類': Soup,
  'スープ・汁物': CupSoda,
  'お菓子': Cookie,
  'デザート': IceCream,
  'パン': Croissant,
  'お弁当': Package,
  'その他': Utensils,
}
```

変更点：
- 各カテゴリーに固有のアイコンを割り当て
- 必要なアイコンをlucide-reactからインポート
- 既存のコンポーネント構造とロジックは維持

## Data Models

### Recipe Category Icon Mapping

| Category | Icon (lucide-react) | 説明 |
|----------|---------------------|------|
| 肉料理 | Beef | 牛肉のアイコン |
| 魚介料理 | Fish | 魚のアイコン |
| 野菜料理 | Carrot | 人参のアイコン |
| サラダ | Salad | サラダボウルのアイコン |
| ご飯もの | Bowl | 丼のアイコン |
| 麺類 | Soup | スープ/麺のアイコン |
| スープ・汁物 | CupSoda | カップのアイコン |
| お菓子 | Cookie | クッキーのアイコン |
| デザート | IceCream | アイスクリームのアイコン |
| パン | Croissant | クロワッサンのアイコン |
| お弁当 | Package | パッケージ/弁当箱のアイコン |
| その他 | Utensils | 食器のアイコン（デフォルト） |

注：既存のUIスタイル（円形背景、選択状態の色変更など）は維持されます。

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Complete category icon mapping

*For any* of the 12 defined recipe categories, the categoryIcons mapping should return a valid icon component (not null or undefined)

**Validates: Requirements 1.1, 1.2, 2.1**

### Property 2: Selected category visual state

*For any* category button, when that category is selected (matches the current tag parameter), the rendered component should apply the selected visual style (primary background and white icon color)

**Validates: Requirements 3.1**

### Property 3: Category selection toggle

*For any* category, clicking it when selected should deselect it (remove the tag parameter), and clicking it when not selected should select it (set the tag parameter to that category)

**Validates: Requirements 3.3**

## Error Handling

### Missing Icon Mapping
- If a category somehow lacks an icon mapping (defensive programming), the component should fall back to the Utensils icon
- This should not cause the component to crash or fail to render

### Component Rendering Errors
- If an icon component fails to render, the CategoryFilter should still display correctly with the category label
- The circular button background should still be visible even if the icon fails

## Testing Strategy

### Unit Testing

We will use Jest and React Testing Library for unit tests:

1. **Icon Mapping Tests**
   - Test that categoryIcons mapping contains all 12 defined categories
   - Test that each mapped icon is a valid React component
   - Test that the fallback to Utensils works for undefined categories

2. **Component Tests**
   - Test that CategoryFilter renders all 12 category buttons
   - Test that each button displays the correct icon for its category
   - Test that selected category displays with primary background
   - Test that clicking a category triggers the correct navigation

### Property-Based Testing

We will use fast-check library for property-based testing in TypeScript:

**Configuration:**
- Each property-based test should run a minimum of 100 iterations
- Tests should use appropriate generators for category data

**Property Tests:**

1. **Property 1: Complete category icon mapping**
   - Tag: `**Feature: recipe-category-icons, Property 1: Complete category icon mapping**`
   - Generate: All 12 defined categories from RECIPE_CATEGORIES
   - Verify: Each category has a corresponding entry in categoryIcons mapping that is not null/undefined

2. **Property 2: Selected category visual state**
   - Tag: `**Feature: recipe-category-icons, Property 2: Selected category visual state**`
   - Generate: Random category and selection state
   - Verify: When category matches selectedTag, the component applies 'bg-primary' and 'text-white' classes

3. **Property 3: Category selection toggle**
   - Tag: `**Feature: recipe-category-icons, Property 3: Category selection toggle**`
   - Generate: Random category and current selection state
   - Verify: Clicking toggles the tag parameter correctly (adds if not selected, removes if selected)

Each property-based test must be implemented as a SINGLE test that validates the corresponding correctness property from this design document.

## Implementation Notes

### Icon Selection Rationale
- Each icon was chosen to visually represent its category
- Icons are from lucide-react library which is already used in the project
- Icons should be recognizable even at small sizes (h-8 w-8)

### No Database Changes Required
- This feature only affects the UI presentation layer
- No changes to Recipe data model or database schema are needed
- Categories are already defined in RECIPE_CATEGORIES constant

### Backward Compatibility
- Existing functionality is preserved
- Only the visual representation of category buttons changes
- All existing event handlers and navigation logic remain unchanged

### Performance Considerations
- Icon components are lightweight and should not impact rendering performance
- The component already uses proper React patterns (client component, hooks)
- No additional optimization needed for this change

### Accessibility
- Existing aria-labels and semantic HTML are maintained
- Icon color contrast meets WCAG standards (primary color on white/orange backgrounds)
- Category labels provide text alternatives for screen readers
