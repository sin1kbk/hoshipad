/**
 * 画像のスコアリングユーティリティ
 */

/**
 * 画像の適切さをスコアリング
 * @param {HTMLImageElement} img - 評価する画像要素
 * @returns {number} スコア（高いほど適切）
 */
export function scoreImage(img) {
  let score = 0;

  // 幅によるスコアリング
  const width = Math.max(img.naturalWidth, img.width || 0);
  if (width > 500) {
    score += 1000;
  }

  // ヘッダー内の画像は除外
  if (img.closest('header')) {
    score -= 500;
  }

  // alt属性によるスコアリング
  const alt = img.alt || '';
  if (alt.length > 20) {
    score += 100;
  }

  // プロフィール画像は除外
  if (alt.includes('profile') || alt.includes('プロフィール')) {
    score -= 500;
  }

  return score;
}

/**
 * 画像のリストをスコアでソート
 * @param {string} selector - CSSセレクター
 * @returns {Array<{img: HTMLImageElement, score: number}>} スコア付き画像のリスト（降順）
 */
export function getBestImages(selector) {
  return Array.from(document.querySelectorAll(selector))
    .map(img => ({
      img: img,
      score: scoreImage(img)
    }))
    .sort((a, b) => b.score - a.score);
}
