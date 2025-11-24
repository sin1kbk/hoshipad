-- recipesテーブルにユーザーIDカラムを追加
ALTER TABLE recipes
ADD COLUMN user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL;

-- インデックスの作成
CREATE INDEX idx_recipes_user_id ON recipes(user_id);

-- 既存のRLSポリシーを削除
DROP POLICY IF EXISTS "Anyone can read recipes" ON recipes;
DROP POLICY IF EXISTS "Anyone can insert recipes" ON recipes;
DROP POLICY IF EXISTS "Anyone can update recipes" ON recipes;
DROP POLICY IF EXISTS "Anyone can delete recipes" ON recipes;

-- 新しいRLSポリシーを作成

-- 全員が全てのレシピを読み取り可能
CREATE POLICY "Anyone can read recipes"
  ON recipes FOR SELECT
  TO anon, authenticated
  USING (true);

-- 認証済みユーザーはレシピを挿入可能
CREATE POLICY "Authenticated users can insert recipes"
  ON recipes FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- ユーザーは自分のレシピのみ更新可能
-- user_idがNULLのレシピ(既存の匿名レシピ)は誰も更新できない
CREATE POLICY "Users can update their own recipes"
  ON recipes FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- ユーザーは自分のレシピのみ削除可能
-- user_idがNULLのレシピ(既存の匿名レシピ)は誰も削除できない
CREATE POLICY "Users can delete their own recipes"
  ON recipes FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);
