import { NextRequest, NextResponse } from 'next/server'
import * as cheerio from 'cheerio'
import { Ingredient, RecipeCategory, RECIPE_CATEGORIES } from '@/types/recipe'

export async function POST(request: NextRequest) {
  try {
    const { url } = await request.json()

    if (!url || !url.includes('cookpad.com')) {
      return NextResponse.json(
        { error: 'Valid Cookpad URL is required' },
        { status: 400 }
      )
    }

    const response = await fetch(url)
    if (!response.ok) {
      return NextResponse.json(
        { error: 'Failed to fetch recipe' },
        { status: 500 }
      )
    }

    const html = await response.text()
    const $ = cheerio.load(html)

    // タイトルを取得
    const title = $('h1').first().text().trim()

    // 画像URLを取得
    let imageUrl = $('meta[property="og:image"]').attr('content') || ''
    if (imageUrl.startsWith('//')) {
      imageUrl = `https:${imageUrl}`
    }

    // 材料を取得
    const ingredients: Ingredient[] = []
    $('.ingredient_row, .ingredient_name').each((_, element) => {
      const name = $(element).find('.ingredient_name, .name').text().trim()
      const amount = $(element).find('.ingredient_quantity, .quantity').text().trim()

      if (name && amount) {
        ingredients.push({ name, amount })
      }
    })

    // カテゴリを推定
    const suggestedCategory = suggestCategory(title, ingredients)

    return NextResponse.json({
      title,
      imageUrl,
      ingredients,
      suggestedCategory,
    })
  } catch (error) {
    console.error('Scrape error:', error)
    return NextResponse.json(
      { error: 'Failed to scrape recipe' },
      { status: 500 }
    )
  }
}

function suggestCategory(title: string, ingredients: Ingredient[]): RecipeCategory {
  const allText = `${title} ${ingredients.map(i => i.name).join(' ')}`.toLowerCase()

  if (/肉|鶏|豚|牛|チキン/.test(allText)) {
    return '肉料理'
  }
  if (/魚|エビ|イカ|貝|海鮮/.test(allText)) {
    return '魚介料理'
  }
  if (/サラダ/.test(allText)) {
    return 'サラダ'
  }
  if (/ご飯|丼|チャーハン|リゾット/.test(allText)) {
    return 'ご飯もの'
  }
  if (/麺|パスタ|うどん|そば|ラーメン/.test(allText)) {
    return '麺類'
  }
  if (/スープ|汁|味噌汁/.test(allText)) {
    return 'スープ・汁物'
  }
  if (/ケーキ|クッキー|お菓子/.test(allText)) {
    return 'お菓子'
  }
  if (/デザート|プリン|ゼリー/.test(allText)) {
    return 'デザート'
  }
  if (/パン/.test(allText)) {
    return 'パン'
  }
  if (/弁当/.test(allText)) {
    return 'お弁当'
  }
  if (/野菜|キャベツ|にんじん|大根|トマト|なす|ピーマン/.test(allText)) {
    return '野菜料理'
  }

  return 'その他'
}
