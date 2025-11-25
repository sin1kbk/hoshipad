/**
 * hoshipad ブックマークレット
 * レシピページからURL、タイトル、画像を抽出してhoshipadに送信
 */

import { extractInstagramData } from './extractors/instagram.js';
import { extractCookpadData } from './extractors/cookpad.js';
import { extractGenericData } from './extractors/generic.js';

(function() {
  const url = window.location.href;
  let title = document.title;
  let imageUrl = '';
  let ingredients = [];

  // Instagramの場合は専用ロジックを使用
  if (title === 'Instagram') {
    const data = extractInstagramData();
    title = data.title;
    imageUrl = data.imageUrl;
  }
  // Cookpadの場合は専用ロジックを使用
  else if (url.includes('cookpad.com')) {
    const data = extractCookpadData();
    imageUrl = data.imageUrl;
    ingredients = data.ingredients || [];
  }
  // その他のページは汎用ロジック
  else {
    const data = extractGenericData();
    imageUrl = data.imageUrl;
  }

  // URLパラメータを構築
  const params = new URLSearchParams({
    url: url,
    title: title
  });

  if (imageUrl) {
    params.append('image', imageUrl);
  }

  // 材料がある場合は追加
  if (ingredients.length > 0) {
    const ingredientsText = ingredients
      .map(i => `${i.name}:${i.quantity}`)
      .join('\n');
    params.append('ingredients', ingredientsText);
  }

  // ビルド時に環境変数で置き換えられるプレースホルダー
  const targetUrl = '%%TARGET_URL%%';
  window.location.href = `${targetUrl}/add?${params.toString()}`;
})();
