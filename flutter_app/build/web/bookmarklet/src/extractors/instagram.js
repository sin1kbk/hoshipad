/**
 * Instagram専用のデータ抽出ロジック
 */

import { getBestImages } from '../utils/scoring.js';

/**
 * InstagramページからタイトルとイメージURLを抽出
 * @returns {{title: string, imageUrl: string}}
 */
export function extractInstagramData() {
  let title = 'Instagram';
  let imageUrl = '';

  // 画像の抽出
  // まずarticle内の画像を優先
  const articleImgs = getBestImages('article img');
  if (articleImgs.length > 0 && articleImgs[0].score > 0) {
    imageUrl = articleImgs[0].img.src;
  } else {
    // article内になければ全体から探す
    const allImgs = getBestImages('img');
    if (allImgs.length > 0 && allImgs[0].score > 0) {
      imageUrl = allImgs[0].img.src;
    } else {
      // それでもなければog:imageを使用
      const ogImage = document.querySelector('meta[property="og:image"]');
      if (ogImage) {
        imageUrl = ogImage.getAttribute('content');
      }
    }
  }

  // タイトルの抽出
  const ogTitle = document.querySelector('meta[property="og:title"]');
  const ogDesc = document.querySelector('meta[property="og:description"]');
  let foundTitle = false;

  // og:titleから抽出を試みる
  if (ogTitle) {
    const ogTitleContent = ogTitle.getAttribute('content');
    if (ogTitleContent) {
      const lines = ogTitleContent.split('\n');
      for (let i = 0; i < lines.length; i++) {
        const line = lines[i].trim();
        // 適切なタイトル行を判定
        if (
          line &&
          !line.startsWith('・') &&
          !line.startsWith('［') &&
          !line.startsWith('#') &&
          !line.match(/^ー+$/) &&
          line.length > 3 &&
          line.length < 50 &&
          !line.includes('@') &&
          !line.includes('Instagram')
        ) {
          title = line;
          foundTitle = true;
          break;
        }
      }
    }
  }

  // og:titleで見つからなければog:descriptionから
  if (!foundTitle && ogDesc) {
    const descContent = ogDesc.getAttribute('content');
    if (descContent) {
      const lines2 = descContent.split('\n').filter(l => l.trim());
      for (let j = 0; j < lines2.length; j++) {
        const trimmed = lines2[j].trim();
        if (
          trimmed &&
          !trimmed.match(/^\d/) &&
          !trimmed.startsWith('・') &&
          !trimmed.startsWith('［') &&
          !trimmed.startsWith('#') &&
          !trimmed.match(/^ー+$/) &&
          trimmed.length > 3 &&
          trimmed.length < 50
        ) {
          title = trimmed;
          break;
        }
      }
      // それでも見つからない場合は最初の行を使用
      if (title === 'Instagram' && lines2.length > 0) {
        title = lines2[0].trim() || 'Instagram Post';
      }
    }
  }

  return { title, imageUrl };
}
