import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

enum RecipeSource {
  @JsonValue('youtube')
  youtube,
  @JsonValue('instagram')
  instagram,
  @JsonValue('twitter')
  twitter,
  @JsonValue('cookpad')
  cookpad,
}

enum RecipeCategory {
  @JsonValue('肉料理')
  meat,
  @JsonValue('魚介料理')
  seafood,
  @JsonValue('野菜料理')
  vegetable,
  @JsonValue('サラダ')
  salad,
  @JsonValue('ご飯もの')
  rice,
  @JsonValue('麺類')
  noodle,
  @JsonValue('スープ・汁物')
  soup,
  @JsonValue('お菓子')
  sweets,
  @JsonValue('デザート')
  dessert,
  @JsonValue('パン')
  bread,
  @JsonValue('お弁当')
  bento,
  @JsonValue('その他')
  other,
}

extension RecipeCategoryExtension on RecipeCategory {
  String get displayName {
    switch (this) {
      case RecipeCategory.meat:
        return '肉料理';
      case RecipeCategory.seafood:
        return '魚介料理';
      case RecipeCategory.vegetable:
        return '野菜料理';
      case RecipeCategory.salad:
        return 'サラダ';
      case RecipeCategory.rice:
        return 'ご飯もの';
      case RecipeCategory.noodle:
        return '麺類';
      case RecipeCategory.soup:
        return 'スープ・汁物';
      case RecipeCategory.sweets:
        return 'お菓子';
      case RecipeCategory.dessert:
        return 'デザート';
      case RecipeCategory.bread:
        return 'パン';
      case RecipeCategory.bento:
        return 'お弁当';
      case RecipeCategory.other:
        return 'その他';
    }
  }
}

extension RecipeSourceExtension on RecipeSource {
  String get displayName {
    switch (this) {
      case RecipeSource.youtube:
        return 'YouTube';
      case RecipeSource.instagram:
        return 'Instagram';
      case RecipeSource.twitter:
        return 'Twitter';
      case RecipeSource.cookpad:
        return 'クックパッド';
    }
  }
}

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String name,
    required String amount,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required int id,
    required String title,
    required String url,
    @JsonKey(name: 'image_url') required String imageUrl,
    String? notes,
    required RecipeSource source,
    List<String>? tags,
    @JsonKey(name: 'user_id') String? userId,
    List<Ingredient>? ingredients,
    @JsonKey(name: 'like_count') @Default(0) int likeCount,
    @JsonKey(name: 'is_liked_by_current_user') @Default(false) bool isLikedByCurrentUser,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}

@freezed
class InsertRecipe with _$InsertRecipe {
  const factory InsertRecipe({
    required String title,
    required String url,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(includeIfNull: false) String? notes,
    required RecipeSource source,
    @JsonKey(includeIfNull: false) List<String>? tags,
    @JsonKey(name: 'user_id', includeIfNull: false) String? userId,
    @JsonKey(includeIfNull: false) List<Ingredient>? ingredients,
  }) = _InsertRecipe;

  factory InsertRecipe.fromJson(Map<String, dynamic> json) =>
      _$InsertRecipeFromJson(json);
}
