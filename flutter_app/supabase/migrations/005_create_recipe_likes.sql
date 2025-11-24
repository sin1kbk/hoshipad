-- Create recipe_likes table for tracking user likes
-- This table maintains a many-to-many relationship between users and recipes

-- Create the recipe_likes table
CREATE TABLE IF NOT EXISTS recipe_likes (
  id BIGSERIAL PRIMARY KEY,
  recipe_id BIGINT NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Ensure a user can only like a recipe once
  UNIQUE(recipe_id, user_id)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_recipe_likes_recipe_id ON recipe_likes(recipe_id);
CREATE INDEX IF NOT EXISTS idx_recipe_likes_user_id ON recipe_likes(user_id);
CREATE INDEX IF NOT EXISTS idx_recipe_likes_created_at ON recipe_likes(created_at DESC);

-- Enable Row Level Security
ALTER TABLE recipe_likes ENABLE ROW LEVEL SECURITY;

-- RLS Policies for recipe_likes

-- Allow users to view all likes
CREATE POLICY "Users can view all recipe likes"
  ON recipe_likes FOR SELECT
  USING (true);

-- Allow authenticated users to like recipes
CREATE POLICY "Authenticated users can like recipes"
  ON recipe_likes FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Allow users to unlike their own likes
CREATE POLICY "Users can unlike their own likes"
  ON recipe_likes FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create a function to get like count for a recipe
CREATE OR REPLACE FUNCTION get_recipe_like_count(recipe_id_param BIGINT)
RETURNS BIGINT AS $$
  SELECT COUNT(*)::BIGINT
  FROM recipe_likes
  WHERE recipe_id = recipe_id_param;
$$ LANGUAGE SQL STABLE;

-- Create a function to check if current user has liked a recipe
CREATE OR REPLACE FUNCTION has_user_liked_recipe(recipe_id_param BIGINT, user_id_param UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS(
    SELECT 1
    FROM recipe_likes
    WHERE recipe_id = recipe_id_param AND user_id = user_id_param
  );
$$ LANGUAGE SQL STABLE;

-- Add comments
COMMENT ON TABLE recipe_likes IS 'Tracks which users have liked which recipes';
COMMENT ON FUNCTION get_recipe_like_count IS 'Returns the total number of likes for a recipe';
COMMENT ON FUNCTION has_user_liked_recipe IS 'Checks if a specific user has liked a specific recipe';
