-- Add tags column to recipes table
-- This replaces the old category column with a flexible tags array

-- Step 1: Make the old category column nullable (if it exists)
ALTER TABLE recipes ALTER COLUMN category DROP NOT NULL;

-- Step 2: Add the tags column as an array of text
ALTER TABLE recipes ADD COLUMN IF NOT EXISTS tags text[];

-- Step 3: Migrate existing category data to tags (if category exists and is not null)
UPDATE recipes
SET tags = ARRAY[category]
WHERE category IS NOT NULL AND tags IS NULL;

-- Step 4: Drop the old category column (uncomment after verifying data migration)
ALTER TABLE recipes DROP COLUMN IF EXISTS category;

-- Create an index on tags for better query performance
CREATE INDEX IF NOT EXISTS idx_recipes_tags ON recipes USING GIN (tags);

-- Add a comment to document the column
COMMENT ON COLUMN recipes.tags IS 'Array of tags/categories for the recipe. Can include both preset and custom tags.';
