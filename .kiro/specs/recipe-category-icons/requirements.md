# Requirements Document

## Introduction

「カテゴリーから探す」欄に表示される各料理種別に対して、適切なアイコンを使い分ける機能を実装します。現在、全てのカテゴリーが同じ`Utensils`アイコンを使用していますが、料理のカテゴリー（肉料理、魚介料理、野菜料理など）に応じて視覚的に区別できる異なるアイコンを表示することで、ユーザーがカテゴリーを素早く識別し、目的のカテゴリーを選択しやすくします。

## Glossary

- **Category Filter**: ホーム画面の「カテゴリーから探す」欄に表示されるカテゴリー選択UI
- **Recipe Category**: レシピの料理種別（肉料理、魚介料理、野菜料理、サラダ、ご飯もの、麺類、スープ・汁物、お菓子、デザート、パン、お弁当、その他）
- **Category Icon**: 各料理種別に対応する視覚的なアイコン
- **Category Filter System**: カテゴリーフィルターの表示と動作を管理するシステム

## Requirements

### Requirement 1

**User Story:** ユーザーとして、カテゴリーフィルターに各料理種別を示す異なるアイコンが表示されることで、目的のカテゴリーを素早く識別して選択したい

#### Acceptance Criteria

1. WHEN the Category Filter displays a category button THEN the Category Filter System SHALL display the corresponding Category Icon for that category
2. WHEN multiple category buttons are displayed THEN the Category Filter System SHALL display different Category Icons for each category
3. WHEN the Category Icon is displayed THEN the Category Filter System SHALL ensure the icon is visually distinct and recognizable
4. WHEN a user views the Category Filter THEN the Category Filter System SHALL display all 12 category icons simultaneously in a horizontal scrollable list

### Requirement 2

**User Story:** 開発者として、各料理種別に対して適切なアイコンがマッピングされることで、一貫性のある視覚表現を提供したい

#### Acceptance Criteria

1. WHEN the Recipe System maps a category to an icon THEN the Recipe System SHALL use a predefined mapping for all 12 defined categories
2. WHEN the category is "肉料理" THEN the Recipe System SHALL display a meat-related icon
3. WHEN the category is "魚介料理" THEN the Recipe System SHALL display a fish-related icon
4. WHEN the category is "野菜料理" THEN the Recipe System SHALL display a vegetable-related icon
5. WHEN the category is "サラダ" THEN the Recipe System SHALL display a salad-related icon
6. WHEN the category is "ご飯もの" THEN the Recipe System SHALL display a rice-related icon
7. WHEN the category is "麺類" THEN the Recipe System SHALL display a noodle-related icon
8. WHEN the category is "スープ・汁物" THEN the Recipe System SHALL display a soup-related icon
9. WHEN the category is "お菓子" THEN the Recipe System SHALL display a sweets-related icon
10. WHEN the category is "デザート" THEN the Recipe System SHALL display a dessert-related icon
11. WHEN the category is "パン" THEN the Recipe System SHALL display a bread-related icon
12. WHEN the category is "お弁当" THEN the Recipe System SHALL display a bento-related icon
13. WHEN the category is "その他" THEN the Recipe System SHALL display a generic food-related icon

### Requirement 3

**User Story:** ユーザーとして、カテゴリーアイコンが選択状態を視覚的に示すことで、現在どのカテゴリーでフィルタリングされているかを理解したい

#### Acceptance Criteria

1. WHEN a category is selected THEN the Category Filter System SHALL display the selected category icon with a distinct visual style
2. WHEN no category is selected THEN the Category Filter System SHALL display all category icons in their default visual style
3. WHEN a user clicks a selected category THEN the Category Filter System SHALL deselect the category and return the icon to its default visual style
