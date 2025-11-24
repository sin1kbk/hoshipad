-- 材料情報を保存するためのカラムを追加
ALTER TABLE recipes
ADD COLUMN ingredients JSONB;

-- 材料カラムにコメントを追加
COMMENT ON COLUMN recipes.ingredients IS '材料リスト（JSON配列形式: [{"name": "水菜", "amount": "60g"}, ...]）';

-- 材料カラムのインデックスを作成（検索用）
CREATE INDEX idx_recipes_ingredients ON recipes USING GIN (ingredients);
