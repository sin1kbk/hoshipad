# Implementation Plan

- [x] 1. Update CategoryFilter component with category-specific icons
  - Update the categoryIcons mapping in CategoryFilter component to use appropriate icons for each category
  - Import all required icon components from lucide-react (Beef, Fish, Carrot, Salad, Bowl, Soup, CupSoda, Cookie, IceCream, Croissant, Package)
  - Replace all Utensils entries with category-specific icons according to the design document mapping
  - Keep Utensils as the icon for 'その他' category
  - Verify that the component still renders correctly with the new icons
  - _Requirements: 1.1, 1.2, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 2.10, 2.11, 2.12, 2.13_

- [x] 1.1 Write property test for complete category icon mapping
  - **Property 1: Complete category icon mapping**
  - **Validates: Requirements 1.1, 1.2, 2.1**

- [x] 1.2 Write property test for selected category visual state
  - **Property 2: Selected category visual state**
  - **Validates: Requirements 3.1**

- [x] 1.3 Write property test for category selection toggle
  - **Property 3: Category selection toggle**
  - **Validates: Requirements 3.3**

- [x] 1.4 Write unit tests for CategoryFilter component
  - Test that all 12 category buttons are rendered
  - Test that each button displays the correct icon
  - Test that selected category has correct styling
  - Test that clicking a category triggers navigation
  - _Requirements: 1.1, 1.2, 1.4, 3.1, 3.2, 3.3_

- [ ] 2. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.
