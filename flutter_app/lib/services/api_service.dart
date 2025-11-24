import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recipe.dart';

class ApiService {
  final SupabaseClient _supabase;

  ApiService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<List<Recipe>> getAllRecipes() async {
    final response = await _supabase
        .from('recipes')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((json) => Recipe.fromJson(json)).toList();
  }

  /// ユーザーのレシピのみを取得
  Future<List<Recipe>> getUserRecipes(String userId) async {
    final response = await _supabase
        .from('recipes')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Recipe.fromJson(json)).toList();
  }

  Future<List<Recipe>> searchRecipes({
    String? query,
    RecipeSource? source,
    RecipeCategory? category,
  }) async {
    // 最初にselectを呼び出す
    var queryBuilder = _supabase.from('recipes').select();

    // フィルター適用
    if (source != null) {
      queryBuilder = queryBuilder.eq('source', source.name);
    }

    if (category != null) {
      queryBuilder = queryBuilder.eq('category', category.displayName);
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
    return (response as List).map((json) => Recipe.fromJson(json)).toList();
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
    final response = await _supabase
        .from('recipes')
        .update(recipe.toJson())
        .eq('id', id)
        .select()
        .single();

    return Recipe.fromJson(response);
  }

  Future<void> deleteRecipe(int id) async {
    await _supabase.from('recipes').delete().eq('id', id);
  }
}
