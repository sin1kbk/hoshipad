import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';
import '../models/recipe.dart';

/// Cookpadからレシピ情報を取得するサービス
class CookpadScraperService {
  /// レシピメタデータを取得
  Future<RecipeMetadata?> scrapeRecipe(String url) async {
    try {
      // CookpadのURLかチェック
      if (!url.contains('cookpad.com')) {
        return null;
      }

      // HTMLを取得
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        return null;
      }

      // HTMLをパース
      final document = html_parser.parse(response.body);

      // タイトルを取得
      final title = _extractTitle(document);
      if (title == null) {
        return null;
      }

      // 画像URLを取得
      final imageUrl = _extractImageUrl(document);
      if (imageUrl == null) {
        return null;
      }

      // 材料を取得
      final ingredients = _extractIngredients(document);

      // カテゴリを推定
      final suggestedCategory = _suggestCategory(title, ingredients);

      return RecipeMetadata(
        title: title,
        imageUrl: imageUrl,
        ingredients: ingredients,
        suggestedCategory: suggestedCategory,
      );
    } catch (e) {
      print('Error scraping recipe: $e');
      return null;
    }
  }

  /// タイトルを抽出
  String? _extractTitle(Document document) {
    // h1タグからタイトルを取得
    final h1Elements = document.querySelectorAll('h1');
    for (final element in h1Elements) {
      final text = element.text.trim();
      if (text.isNotEmpty && !text.contains('クックパッド')) {
        return text;
      }
    }
    return null;
  }

  /// 画像URLを抽出
  String? _extractImageUrl(Document document) {
    // レシピ画像を取得（複数のセレクタを試す）
    final selectors = [
      'img[alt*="レシピ"]',
      'img[class*="recipe"]',
      'meta[property="og:image"]',
    ];

    for (final selector in selectors) {
      final element = document.querySelector(selector);
      if (element != null) {
        // imgタグの場合はsrc、metaタグの場合はcontent
        final imageUrl = element.attributes['src'] ?? element.attributes['content'];
        if (imageUrl != null && imageUrl.isNotEmpty) {
          // 相対URLの場合は絶対URLに変換
          if (imageUrl.startsWith('//')) {
            return 'https:$imageUrl';
          } else if (imageUrl.startsWith('/')) {
            return 'https://cookpad.com$imageUrl';
          }
          return imageUrl;
        }
      }
    }
    return null;
  }

  /// 材料を抽出
  List<Ingredient> _extractIngredients(Document document) {
    final ingredients = <Ingredient>[];

    // 材料セクションを探す
    final ingredientElements = document.querySelectorAll('li');

    for (final element in ingredientElements) {
      final text = element.text.trim();

      // 材料らしいテキストをパース
      // 例: "水菜 60g" または "水菜　60g"
      if (text.isEmpty || text.length > 100) continue;

      // スペースまたは全角スペースで分割
      final parts = text.split(RegExp(r'\s+|　+'));
      if (parts.length >= 2) {
        final name = parts[0].trim();
        final amount = parts.sublist(1).join(' ').trim();

        // 材料名が妥当かチェック（短すぎる、数字のみ、などを除外）
        if (name.isNotEmpty &&
            amount.isNotEmpty &&
            name.length > 1 &&
            !RegExp(r'^\d+$').hasMatch(name)) {
          ingredients.add(Ingredient(
            name: name,
            amount: amount,
          ));
        }
      }
    }

    return ingredients;
  }

  /// タイトルと材料からカテゴリを推定
  String _suggestCategory(String title, List<Ingredient> ingredients) {
    final titleLower = title.toLowerCase();
    final allText = '$title ${ingredients.map((i) => i.name).join(' ')}'.toLowerCase();

    // キーワードベースでカテゴリを推定
    if (allText.contains('肉') ||
        allText.contains('鶏') ||
        allText.contains('豚') ||
        allText.contains('牛') ||
        allText.contains('チキン')) {
      return RecipeCategory.meat.displayName;
    }

    if (allText.contains('魚') ||
        allText.contains('エビ') ||
        allText.contains('イカ') ||
        allText.contains('貝') ||
        allText.contains('海鮮')) {
      return RecipeCategory.seafood.displayName;
    }

    if (allText.contains('サラダ')) {
      return RecipeCategory.salad.displayName;
    }

    if (allText.contains('ご飯') ||
        allText.contains('丼') ||
        allText.contains('チャーハン') ||
        allText.contains('リゾット')) {
      return RecipeCategory.rice.displayName;
    }

    if (allText.contains('麺') ||
        allText.contains('パスタ') ||
        allText.contains('うどん') ||
        allText.contains('そば') ||
        allText.contains('ラーメン')) {
      return RecipeCategory.noodle.displayName;
    }

    if (allText.contains('スープ') ||
        allText.contains('汁') ||
        allText.contains('味噌汁')) {
      return RecipeCategory.soup.displayName;
    }

    if (allText.contains('ケーキ') ||
        allText.contains('クッキー') ||
        allText.contains('お菓子')) {
      return RecipeCategory.sweets.displayName;
    }

    if (allText.contains('デザート') ||
        allText.contains('プリン') ||
        allText.contains('ゼリー')) {
      return RecipeCategory.dessert.displayName;
    }

    if (allText.contains('パン')) {
      return RecipeCategory.bread.displayName;
    }

    if (allText.contains('弁当')) {
      return RecipeCategory.bento.displayName;
    }

    // 野菜が多い場合は野菜料理
    final vegetableKeywords = ['野菜', 'キャベツ', 'にんじん', '大根', 'トマト', 'なす', 'ピーマン'];
    if (vegetableKeywords.any((keyword) => allText.contains(keyword))) {
      return RecipeCategory.vegetable.displayName;
    }

    // デフォルトはその他
    return RecipeCategory.other.displayName;
  }
}

/// レシピメタデータ
class RecipeMetadata {
  final String title;
  final String imageUrl;
  final List<Ingredient> ingredients;
  final String? suggestedCategory;

  RecipeMetadata({
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    this.suggestedCategory,
  });
}
