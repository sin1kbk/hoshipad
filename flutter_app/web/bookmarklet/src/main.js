/**
 * hoshipad ブックマークレット
 * レシピページからURL、タイトル、画像を抽出してhoshipadに送信
 */

import { extractInstagramData } from './extractors/instagram.js';
import { extractGenericData } from './extractors/generic.js';

(function() {
  const url = window.location.href;
  let title = document.title;
  let imageUrl = '';

  // Instagramの場合は専用ロジックを使用
  if (title === 'Instagram') {
    const data = extractInstagramData();
    title = data.title;
    imageUrl = data.imageUrl;
  } else {
    // その他のページは汎用ロジック
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

  // ビルド時に環境変数で置き換えられるプレースホルダー
  const targetUrl = '%%TARGET_URL%%';
  window.location.href = `${targetUrl}/add?${params.toString()}`;
})();
