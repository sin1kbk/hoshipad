-- レシピテーブルの作成
CREATE TABLE recipes (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  url TEXT NOT NULL,
  image_url TEXT NOT NULL,
  notes TEXT,
  source VARCHAR(20) NOT NULL CHECK (source IN ('youtube', 'instagram', 'twitter', 'cookpad')),
  category VARCHAR(30) NOT NULL CHECK (category IN (
    '肉料理', '魚介料理', '野菜料理', 'サラダ',
    'ご飯もの', '麺類', 'スープ・汁物', 'お菓子',
    'デザート', 'パン', 'お弁当', 'その他'
  )),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- インデックスの作成
CREATE INDEX idx_recipes_category ON recipes(category);
CREATE INDEX idx_recipes_source ON recipes(source);
CREATE INDEX idx_recipes_created_at ON recipes(created_at DESC);

-- Row Level Security (RLS) を有効化
ALTER TABLE recipes ENABLE ROW LEVEL SECURITY;

-- 全員が読み取り可能
CREATE POLICY "Anyone can read recipes"
  ON recipes FOR SELECT
  TO anon, authenticated
  USING (true);

-- 全員が挿入可能（必要に応じて認証ユーザーのみに制限可能）
CREATE POLICY "Anyone can insert recipes"
  ON recipes FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- 全員が更新可能（必要に応じて認証ユーザーのみに制限可能）
CREATE POLICY "Anyone can update recipes"
  ON recipes FOR UPDATE
  TO anon, authenticated
  USING (true);

-- 全員が削除可能（必要に応じて認証ユーザーのみに制限可能）
CREATE POLICY "Anyone can delete recipes"
  ON recipes FOR DELETE
  TO anon, authenticated
  USING (true);

-- サンプルデータの挿入（オプション）
INSERT INTO recipes (title, url, image_url, notes, source, category) VALUES
  ('簡単！鶏の照り焼き', 'https://example.com/recipe1', 'https://picsum.photos/400/300?random=1', '甘辛タレが絶品', 'youtube', '肉料理'),
  ('さっぱり和風サラダ', 'https://example.com/recipe2', 'https://picsum.photos/400/300?random=2', '野菜たっぷり', 'instagram', 'サラダ'),
  ('本格カルボナーラ', 'https://example.com/recipe3', 'https://picsum.photos/400/300?random=3', '生クリーム不使用', 'cookpad', '麺類');
