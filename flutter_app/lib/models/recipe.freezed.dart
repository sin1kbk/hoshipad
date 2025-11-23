// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return _Recipe.fromJson(json);
}

/// @nodoc
mixin _$Recipe {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  RecipeSource get source => throw _privateConstructorUsedError;
  RecipeCategory get category => throw _privateConstructorUsedError;

  /// Serializes this Recipe to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeCopyWith<Recipe> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeCopyWith<$Res> {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) then) =
      _$RecipeCopyWithImpl<$Res, Recipe>;
  @useResult
  $Res call({
    int id,
    String title,
    String url,
    @JsonKey(name: 'image_url') String imageUrl,
    String? notes,
    RecipeSource source,
    RecipeCategory category,
  });
}

/// @nodoc
class _$RecipeCopyWithImpl<$Res, $Val extends Recipe>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? url = null,
    Object? imageUrl = null,
    Object? notes = freezed,
    Object? source = null,
    Object? category = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as RecipeSource,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as RecipeCategory,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecipeImplCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$$RecipeImplCopyWith(
    _$RecipeImpl value,
    $Res Function(_$RecipeImpl) then,
  ) = __$$RecipeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    String url,
    @JsonKey(name: 'image_url') String imageUrl,
    String? notes,
    RecipeSource source,
    RecipeCategory category,
  });
}

/// @nodoc
class __$$RecipeImplCopyWithImpl<$Res>
    extends _$RecipeCopyWithImpl<$Res, _$RecipeImpl>
    implements _$$RecipeImplCopyWith<$Res> {
  __$$RecipeImplCopyWithImpl(
    _$RecipeImpl _value,
    $Res Function(_$RecipeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? url = null,
    Object? imageUrl = null,
    Object? notes = freezed,
    Object? source = null,
    Object? category = null,
  }) {
    return _then(
      _$RecipeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as RecipeSource,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as RecipeCategory,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeImpl implements _Recipe {
  const _$RecipeImpl({
    required this.id,
    required this.title,
    required this.url,
    @JsonKey(name: 'image_url') required this.imageUrl,
    this.notes,
    required this.source,
    required this.category,
  });

  factory _$RecipeImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String url;
  @override
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @override
  final String? notes;
  @override
  final RecipeSource source;
  @override
  final RecipeCategory category;

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, url: $url, imageUrl: $imageUrl, notes: $notes, source: $source, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    url,
    imageUrl,
    notes,
    source,
    category,
  );

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      __$$RecipeImplCopyWithImpl<_$RecipeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeImplToJson(this);
  }
}

abstract class _Recipe implements Recipe {
  const factory _Recipe({
    required final int id,
    required final String title,
    required final String url,
    @JsonKey(name: 'image_url') required final String imageUrl,
    final String? notes,
    required final RecipeSource source,
    required final RecipeCategory category,
  }) = _$RecipeImpl;

  factory _Recipe.fromJson(Map<String, dynamic> json) = _$RecipeImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get url;
  @override
  @JsonKey(name: 'image_url')
  String get imageUrl;
  @override
  String? get notes;
  @override
  RecipeSource get source;
  @override
  RecipeCategory get category;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InsertRecipe _$InsertRecipeFromJson(Map<String, dynamic> json) {
  return _InsertRecipe.fromJson(json);
}

/// @nodoc
mixin _$InsertRecipe {
  String get title => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  RecipeSource get source => throw _privateConstructorUsedError;
  RecipeCategory get category => throw _privateConstructorUsedError;

  /// Serializes this InsertRecipe to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsertRecipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsertRecipeCopyWith<InsertRecipe> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsertRecipeCopyWith<$Res> {
  factory $InsertRecipeCopyWith(
    InsertRecipe value,
    $Res Function(InsertRecipe) then,
  ) = _$InsertRecipeCopyWithImpl<$Res, InsertRecipe>;
  @useResult
  $Res call({
    String title,
    String url,
    @JsonKey(name: 'image_url') String imageUrl,
    String? notes,
    RecipeSource source,
    RecipeCategory category,
  });
}

/// @nodoc
class _$InsertRecipeCopyWithImpl<$Res, $Val extends InsertRecipe>
    implements $InsertRecipeCopyWith<$Res> {
  _$InsertRecipeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsertRecipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? url = null,
    Object? imageUrl = null,
    Object? notes = freezed,
    Object? source = null,
    Object? category = null,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as RecipeSource,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as RecipeCategory,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InsertRecipeImplCopyWith<$Res>
    implements $InsertRecipeCopyWith<$Res> {
  factory _$$InsertRecipeImplCopyWith(
    _$InsertRecipeImpl value,
    $Res Function(_$InsertRecipeImpl) then,
  ) = __$$InsertRecipeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String url,
    @JsonKey(name: 'image_url') String imageUrl,
    String? notes,
    RecipeSource source,
    RecipeCategory category,
  });
}

/// @nodoc
class __$$InsertRecipeImplCopyWithImpl<$Res>
    extends _$InsertRecipeCopyWithImpl<$Res, _$InsertRecipeImpl>
    implements _$$InsertRecipeImplCopyWith<$Res> {
  __$$InsertRecipeImplCopyWithImpl(
    _$InsertRecipeImpl _value,
    $Res Function(_$InsertRecipeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InsertRecipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? url = null,
    Object? imageUrl = null,
    Object? notes = freezed,
    Object? source = null,
    Object? category = null,
  }) {
    return _then(
      _$InsertRecipeImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as RecipeSource,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as RecipeCategory,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InsertRecipeImpl implements _InsertRecipe {
  const _$InsertRecipeImpl({
    required this.title,
    required this.url,
    @JsonKey(name: 'image_url') required this.imageUrl,
    this.notes,
    required this.source,
    required this.category,
  });

  factory _$InsertRecipeImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsertRecipeImplFromJson(json);

  @override
  final String title;
  @override
  final String url;
  @override
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @override
  final String? notes;
  @override
  final RecipeSource source;
  @override
  final RecipeCategory category;

  @override
  String toString() {
    return 'InsertRecipe(title: $title, url: $url, imageUrl: $imageUrl, notes: $notes, source: $source, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsertRecipeImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, url, imageUrl, notes, source, category);

  /// Create a copy of InsertRecipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsertRecipeImplCopyWith<_$InsertRecipeImpl> get copyWith =>
      __$$InsertRecipeImplCopyWithImpl<_$InsertRecipeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsertRecipeImplToJson(this);
  }
}

abstract class _InsertRecipe implements InsertRecipe {
  const factory _InsertRecipe({
    required final String title,
    required final String url,
    @JsonKey(name: 'image_url') required final String imageUrl,
    final String? notes,
    required final RecipeSource source,
    required final RecipeCategory category,
  }) = _$InsertRecipeImpl;

  factory _InsertRecipe.fromJson(Map<String, dynamic> json) =
      _$InsertRecipeImpl.fromJson;

  @override
  String get title;
  @override
  String get url;
  @override
  @JsonKey(name: 'image_url')
  String get imageUrl;
  @override
  String? get notes;
  @override
  RecipeSource get source;
  @override
  RecipeCategory get category;

  /// Create a copy of InsertRecipe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsertRecipeImplCopyWith<_$InsertRecipeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
