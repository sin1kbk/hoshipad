import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recipe.dart';

class ApiService {
  final SupabaseClient _supabase;

  ApiService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<List<Recipe>> getAllRecipes() async {
    final currentUserId = _supabase.auth.currentUser?.id;

    final response = await _supabase
        .from('recipes')
        .select('''
          *,
          recipe_likes(user_id)
        ''')
        .order('created_at', ascending: false);

    return _parseRecipesWithLikes(response, currentUserId);
  }

  /// ユーザーのレシピのみを取得
  Future<List<Recipe>> getUserRecipes(String userId) async {
    final currentUserId = _supabase.auth.currentUser?.id;

    final response = await _supabase
        .from('recipes')
        .select('''
          *,
          recipe_likes(user_id)
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return _parseRecipesWithLikes(response, currentUserId);
  }

  Future<List<Recipe>> searchRecipes({
    String? query,
    RecipeSource? source,
    String? tag,
  }) async {
    final currentUserId = _supabase.auth.currentUser?.id;

    // 最初にselectを呼び出す（いいね情報を含む）
    var queryBuilder = _supabase.from('recipes').select('''
      *,
      recipe_likes(user_id)
    ''');

    // フィルター適用
    if (source != null) {
      queryBuilder = queryBuilder.eq('source', source.name);
    }

    if (tag != null) {
      queryBuilder = queryBuilder.contains('tags', [tag]);
    }

    // 検索クエリ
    if (query != null && query.isNotEmpty) {
      // Supabaseのテキスト検索を使用
      queryBuilder = queryBuilder.or(
        'title.ilike.%$query%,notes.ilike.%$query%',
      );
    }

    // ソートして結果を取得
    final response = await queryBuilder.order('created_at', ascending: false);
    return _parseRecipesWithLikes(response, currentUserId);
  }

  Future<Recipe> createRecipe(InsertRecipe recipe) async {
    // 現在のユーザーIDを自動的に設定
    final currentUser = _supabase.auth.currentUser;
    final recipeWithUserId = recipe.copyWith(
      userId: currentUser?.id,
    );

    final response = await _supabase
        .from('recipes')
        .insert(recipeWithUserId.toJson())
        .select()
        .single();

    return Recipe.fromJson(response);
  }

  Future<Recipe> updateRecipe(int id, InsertRecipe recipe) async {
    // toJson()を取得してuser_idを除外
    // UPDATE時はuser_idを変更してはいけない
    final json = Map<String, dynamic>.from(recipe.toJson());
    json.remove('user_id');

    final response = await _supabase
        .from('recipes')
        .update(json)
        .eq('id', id)
        .select()
        .single();

    return Recipe.fromJson(response);
  }

  Future<void> deleteRecipe(int id) async {
    await _supabase.from('recipes').delete().eq('id', id);
  }

  /// いいね情報を含むレシピデータをパース
  List<Recipe> _parseRecipesWithLikes(dynamic response, String? currentUserId) {
    final recipes = response as List;

    return recipes.map((json) {
      // recipe_likesからいいね情報を計算
      final likesData = json['recipe_likes'] as List?;

      // いいね数を計算
      final likeCount = likesData?.length ?? 0;

      // 現在のユーザーがいいねしているかチェック
      final isLiked = currentUserId != null &&
          (likesData?.any((like) => like['user_id'] == currentUserId) ?? false);

      // 元のjsonにいいね情報を追加
      final recipeJson = Map<String, dynamic>.from(json);
      recipeJson['like_count'] = likeCount;
      recipeJson['is_liked_by_current_user'] = isLiked;

      // recipe_likesを削除（モデルに不要）
      recipeJson.remove('recipe_likes');

      return Recipe.fromJson(recipeJson);
    }).toList();
  }
}
