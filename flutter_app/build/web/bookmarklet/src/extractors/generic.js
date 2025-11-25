/**
 * 汎用的なページからのデータ抽出ロジック
 */

/**
 * 汎用ページから画像URLを抽出
 * @returns {{imageUrl: string}}
 */
export function extractGenericData() {
  let imageUrl = '';

  // og:imageメタタグから画像を取得
  const ogImage = document.querySelector('meta[property="og:image"]');
  if (ogImage) {
    imageUrl = ogImage.getAttribute('content') || '';
  }

  return { imageUrl };
}
