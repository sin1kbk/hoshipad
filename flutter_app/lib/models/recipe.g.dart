// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IngredientImpl _$$IngredientImplFromJson(Map<String, dynamic> json) =>
    _$IngredientImpl(
      name: json['name'] as String,
      amount: json['amount'] as String,
    );

Map<String, dynamic> _$$IngredientImplToJson(_$IngredientImpl instance) =>
    <String, dynamic>{'name': instance.name, 'amount': instance.amount};

_$RecipeImpl _$$RecipeImplFromJson(Map<String, dynamic> json) => _$RecipeImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  url: json['url'] as String,
  imageUrl: json['image_url'] as String,
  notes: json['notes'] as String?,
  source: $enumDecode(_$RecipeSourceEnumMap, json['source']),
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  userId: json['user_id'] as String?,
  ingredients: (json['ingredients'] as List<dynamic>?)
      ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$RecipeImplToJson(_$RecipeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'image_url': instance.imageUrl,
      'notes': instance.notes,
      'source': _$RecipeSourceEnumMap[instance.source]!,
      'tags': instance.tags,
      'user_id': instance.userId,
      'ingredients': instance.ingredients,
    };

const _$RecipeSourceEnumMap = {
  RecipeSource.youtube: 'youtube',
  RecipeSource.instagram: 'instagram',
  RecipeSource.twitter: 'twitter',
  RecipeSource.cookpad: 'cookpad',
};

_$InsertRecipeImpl _$$InsertRecipeImplFromJson(Map<String, dynamic> json) =>
    _$InsertRecipeImpl(
      title: json['title'] as String,
      url: json['url'] as String,
      imageUrl: json['image_url'] as String,
      notes: json['notes'] as String?,
      source: $enumDecode(_$RecipeSourceEnumMap, json['source']),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      userId: json['user_id'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$InsertRecipeImplToJson(_$InsertRecipeImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'image_url': instance.imageUrl,
      'notes': instance.notes,
      'source': _$RecipeSourceEnumMap[instance.source]!,
      'tags': instance.tags,
      'user_id': instance.userId,
      'ingredients': instance.ingredients,
    };
