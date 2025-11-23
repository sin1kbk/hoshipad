// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeImpl _$$RecipeImplFromJson(Map<String, dynamic> json) => _$RecipeImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  url: json['url'] as String,
  imageUrl: json['image_url'] as String,
  notes: json['notes'] as String?,
  source: $enumDecode(_$RecipeSourceEnumMap, json['source']),
  category: $enumDecode(_$RecipeCategoryEnumMap, json['category']),
);

Map<String, dynamic> _$$RecipeImplToJson(_$RecipeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'image_url': instance.imageUrl,
      'notes': instance.notes,
      'source': _$RecipeSourceEnumMap[instance.source]!,
      'category': _$RecipeCategoryEnumMap[instance.category]!,
    };

const _$RecipeSourceEnumMap = {
  RecipeSource.youtube: 'youtube',
  RecipeSource.instagram: 'instagram',
  RecipeSource.twitter: 'twitter',
  RecipeSource.cookpad: 'cookpad',
};

const _$RecipeCategoryEnumMap = {
  RecipeCategory.meat: '肉料理',
  RecipeCategory.seafood: '魚介料理',
  RecipeCategory.vegetable: '野菜料理',
  RecipeCategory.salad: 'サラダ',
  RecipeCategory.rice: 'ご飯もの',
  RecipeCategory.noodle: '麺類',
  RecipeCategory.soup: 'スープ・汁物',
  RecipeCategory.sweets: 'お菓子',
  RecipeCategory.dessert: 'デザート',
  RecipeCategory.bread: 'パン',
  RecipeCategory.bento: 'お弁当',
  RecipeCategory.other: 'その他',
};

_$InsertRecipeImpl _$$InsertRecipeImplFromJson(Map<String, dynamic> json) =>
    _$InsertRecipeImpl(
      title: json['title'] as String,
      url: json['url'] as String,
      imageUrl: json['image_url'] as String,
      notes: json['notes'] as String?,
      source: $enumDecode(_$RecipeSourceEnumMap, json['source']),
      category: $enumDecode(_$RecipeCategoryEnumMap, json['category']),
    );

Map<String, dynamic> _$$InsertRecipeImplToJson(_$InsertRecipeImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'image_url': instance.imageUrl,
      'notes': instance.notes,
      'source': _$RecipeSourceEnumMap[instance.source]!,
      'category': _$RecipeCategoryEnumMap[instance.category]!,
    };
