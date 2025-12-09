import { render, screen, fireEvent } from '@testing-library/react'
import '@testing-library/jest-dom'
import CategoryFilter from '@/components/recipes/CategoryFilter'
import { RECIPE_CATEGORIES } from '@/types/recipe'
import * as fc from 'fast-check'
import { useRouter, useSearchParams } from 'next/navigation'

// Mock Next.js navigation
jest.mock('next/navigation', () => ({
  useRouter: jest.fn(),
  useSearchParams: jest.fn(),
}))

describe('CategoryFilter - Property-Based Tests', () => {
  beforeEach(() => {
    jest.clearAllMocks()
  })

  /**
   * Feature: recipe-category-icons, Property 1: Complete category icon mapping
   * Validates: Requirements 1.1, 1.2, 2.1
   */
  it('Property 1: Complete category icon mapping - all categories have valid icon mappings', () => {
    // Mock the router and search params
    const mockRouter = { push: jest.fn() }
    const mockSearchParams = new URLSearchParams()
    ;(useRouter as jest.Mock).mockReturnValue(mockRouter)
    ;(useSearchParams as jest.Mock).mockReturnValue(mockSearchParams)
    
    // Render the component once
    const { container } = render(<CategoryFilter />)
    
    fc.assert(
      fc.property(
        fc.constantFrom(...RECIPE_CATEGORIES.map(cat => cat.value)),
        (category) => {
          // Find all buttons with this category label
          const categoryLabel = RECIPE_CATEGORIES.find(c => c.value === category)?.label || category
          const buttons = screen.getAllByText(categoryLabel)
          
          // There should be at least one button with this label
          expect(buttons.length).toBeGreaterThan(0)
          
          // Get the button element
          const categoryButton = buttons[0].closest('button')
          
          // Check that the button exists and has an icon (svg element)
          expect(categoryButton).toBeInTheDocument()
          const icon = categoryButton?.querySelector('svg')
          expect(icon).toBeInTheDocument()
          expect(icon).not.toBeNull()
          
          return true
        }
      ),
      { numRuns: 100 }
    )
  })

  /**
   * Feature: recipe-category-icons, Property 2: Selected category visual state
   * Validates: Requirements 3.1
   */
  it('Property 2: Selected category visual state - selected categories have distinct visual styling', () => {
    fc.assert(
      fc.property(
        fc.constantFrom(...RECIPE_CATEGORIES.map(cat => cat.value)),
        fc.boolean(),
        (category, isSelected) => {
          // Mock the router
          const mockRouter = {
            push: jest.fn(),
          }
          
          // Mock the search params to set the selected category
          const mockSearchParams = new URLSearchParams()
          if (isSelected) {
            mockSearchParams.set('tag', category)
          }
          
          // Apply mocks before rendering
          ;(useRouter as jest.Mock).mockReturnValue(mockRouter)
          ;(useSearchParams as jest.Mock).mockReturnValue(mockSearchParams)
          
          // Render the component with the mocked selection state
          const { container, unmount } = render(<CategoryFilter />)
          
          // Find the button for this category
          const categoryLabel = RECIPE_CATEGORIES.find(c => c.value === category)?.label || category
          const buttons = screen.getAllByText(categoryLabel)
          const categoryButton = buttons[0].closest('button')
          
          expect(categoryButton).toBeInTheDocument()
          
          // Find the icon container div
          const iconContainer = categoryButton?.querySelector('div')
          const icon = categoryButton?.querySelector('svg')
          
          if (isSelected) {
            // When selected, should have primary background
            expect(iconContainer).toHaveClass('bg-primary')
            // Icon should be white
            expect(icon).toHaveClass('text-white')
          } else {
            // When not selected, should have orange background
            expect(iconContainer).toHaveClass('bg-orange-50')
            // Icon should be primary color
            expect(icon).toHaveClass('text-primary')
          }
          
          // Clean up after each iteration
          unmount()
          
          return true
        }
      ),
      { numRuns: 100 }
    )
  })

  /**
   * Feature: recipe-category-icons, Property 3: Category selection toggle
   * Validates: Requirements 3.3
   */
  it('Property 3: Category selection toggle - clicking toggles category selection correctly', () => {
    fc.assert(
      fc.property(
        fc.constantFrom(...RECIPE_CATEGORIES.map(cat => cat.value)),
        fc.boolean(),
        (category, initiallySelected) => {
          // Mock the router - create a fresh mock for each iteration
          const mockPush = jest.fn()
          const mockRouter = {
            push: mockPush,
          }
          
          // Mock the search params to set initial selection state
          const mockSearchParams = new URLSearchParams()
          if (initiallySelected) {
            mockSearchParams.set('tag', category)
          }
          
          // Apply mocks before rendering
          ;(useRouter as jest.Mock).mockReturnValue(mockRouter)
          ;(useSearchParams as jest.Mock).mockReturnValue(mockSearchParams)
          
          // Render the component
          const { unmount } = render(<CategoryFilter />)
          
          // Find and click the button for this category
          const categoryLabel = RECIPE_CATEGORIES.find(c => c.value === category)?.label || category
          const buttons = screen.getAllByText(categoryLabel)
          const categoryButton = buttons[0].closest('button') as HTMLButtonElement
          
          expect(categoryButton).toBeInTheDocument()
          
          // Click the button using fireEvent
          fireEvent.click(categoryButton)
          
          // Verify router.push was called
          expect(mockPush).toHaveBeenCalledTimes(1)
          
          // Get the URL that was pushed
          const pushedUrl = mockPush.mock.calls[0][0]
          
          if (initiallySelected) {
            // If initially selected, clicking should deselect (remove tag parameter)
            // Should navigate to root or URL without the tag parameter
            expect(pushedUrl).toBe('/')
          } else {
            // If not initially selected, clicking should select (add tag parameter)
            expect(pushedUrl).toBe(`/?tag=${encodeURIComponent(category)}`)
          }
          
          // Clean up after each iteration
          unmount()
          
          return true
        }
      ),
      { numRuns: 100 }
    )
  })
})


describe('CategoryFilter - Unit Tests', () => {
  beforeEach(() => {
    jest.clearAllMocks()
  })

  it('renders all 12 category buttons', () => {
    const mockRouter = { push: jest.fn() }
    const mockSearchParams = new URLSearchParams()
    ;(useRouter as jest.Mock).mockReturnValue(mockRouter)
    ;(useSearchParams as jest.Mock).mockReturnValue(mockSearchParams)

    render(<CategoryFilter />)

    // Check that all 12 categories are rendered
    RECIPE_CATEGORIES.forEach((category) => {
      expect(screen.getByText(category.label)).toBeInTheDocument()
    })
  })

  it('displays the correct icon for each category', () => {
    const mockRouter = { push: jest.fn() }
    const mockSearchParams = new URLSearchParams()
    ;(useRouter as jest.Mock).mockReturnValue(mockRouter)
    ;(useSearchParams as jest.Mock).mockReturnValue(mockSearchParams)

    const { container } = render(<CategoryFilter />)

    // Each button should have an SVG icon
    const buttons = container.querySelectorAll('button')
    expect(buttons.length).toBe(12)

    buttons.forEach((button) => {
      const icon = button.querySelector('svg')
      expect(icon).toBeInTheDocument()
    })
  })

  it('applies correct styling to selected category', () => {
    const mockRouter = { push: jest.fn() }
    const mockSearchParams = new URLSearchParams()
    mockSearchParams.set('tag', '肉料理')
    ;(useRouter as jest.Mock).mockReturnValue(mockRouter)
    ;(useSearchParams as jest.Mock).mockReturnValue(mockSearchParams)

    const { container } = render(<CategoryFilter />)

    // Find the selected category button
    const selectedButton = screen.getByText('肉料理').closest('button')
    expect(selectedButton).toBeInTheDocument()

    // Check that it has the primary background
    const iconContainer = selectedButton?.querySelector('div')
    expect(iconContainer).toHaveClass('bg-primary')

    // Check that the icon is white
    const icon = selectedButton?.querySelector('svg')
    expect(icon).toHaveClass('text-white')
  })

  it('triggers navigation when clicking a category', () => {
    const mockPush = jest.fn()
    const mockRouter = { push: mockPush }
    const mockSearchParams = new URLSearchParams()
    ;(useRouter as jest.Mock).mockReturnValue(mockRouter)
    ;(useSearchParams as jest.Mock).mockReturnValue(mockSearchParams)

    render(<CategoryFilter />)

    // Click on a category
    const categoryButton = screen.getByText('肉料理').closest('button') as HTMLButtonElement
    fireEvent.click(categoryButton)

    // Verify router.push was called with the correct URL
    expect(mockPush).toHaveBeenCalledWith('/?tag=%E8%82%89%E6%96%99%E7%90%86')
  })

  it('deselects category when clicking selected category', () => {
    const mockPush = jest.fn()
    const mockRouter = { push: mockPush }
    const mockSearchParams = new URLSearchParams()
    mockSearchParams.set('tag', '肉料理')
    ;(useRouter as jest.Mock).mockReturnValue(mockRouter)
    ;(useSearchParams as jest.Mock).mockReturnValue(mockSearchParams)

    render(<CategoryFilter />)

    // Click on the already selected category
    const categoryButton = screen.getByText('肉料理').closest('button') as HTMLButtonElement
    fireEvent.click(categoryButton)

    // Verify router.push was called to navigate to root (deselect)
    expect(mockPush).toHaveBeenCalledWith('/')
  })
})
