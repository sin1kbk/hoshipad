/**
 * Cookpad専用のデータ抽出ロジック
 */

/**
 * Cookpadページから画像URLと材料を抽出
 * @returns {{imageUrl: string, ingredients: Array<{name: string, quantity: string}>}}
 */
export function extractCookpadData() {
  let imageUrl = '';

  // og:imageメタタグから画像を取得
  const ogImage = document.querySelector('meta[property="og:image"]');
  if (ogImage) {
    imageUrl = ogImage.getAttribute('content') || '';
  }

  // 材料を抽出
  const ingredients = extractIngredients();

  return { imageUrl, ingredients };
}

/**
 * Cookpadページから材料を抽出
 * @returns {Array<{name: string, quantity: string}>}
 */
function extractIngredients() {
  // h2要素で「材料」を含むものを探す
  const h2Elements = Array.from(document.querySelectorAll('h2'));
  const materialH2 = h2Elements.find(h2 => h2.textContent.trim() === '材料');

  const ingredients = [];
  if (!materialH2) return ingredients;

  // h2の親の次の次の兄弟要素が材料リスト
  const parent = materialH2.parentElement;
  if (!parent) return ingredients;

  const ingredientListDiv = parent.nextElementSibling?.nextElementSibling;
  if (!ingredientListDiv) return ingredients;

  // li要素ごとに処理
  const liElements = ingredientListDiv.querySelectorAll('li');

  liElements.forEach(li => {
    // span要素から材料名を取得
    const span = li.querySelector('span');
    // bdi要素から分量を取得
    const bdi = li.querySelector('bdi');

    if (span && bdi) {
      const name = span.textContent.trim();
      const quantity = bdi.textContent.trim();

      if (name && quantity) {
        ingredients.push({ name, quantity });
      }
    }
  });

  return ingredients;
}
