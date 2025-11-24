import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// レシピのいいね機能を管理するプロバイダー
class LikeProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// レシピにいいねを追加
  Future<bool> likeRecipe(int recipeId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _supabase.from('recipe_likes').insert({
        'recipe_id': recipeId,
        'user_id': userId,
      });

      notifyListeners();
      return true;
    } on PostgrestException catch (e) {
      // Unique constraint violation means already liked
      if (e.code == '23505') {
        debugPrint('Recipe already liked by this user');
        return false;
      }
      debugPrint('Error liking recipe: $e');
      rethrow;
    } catch (e) {
      debugPrint('Error liking recipe: $e');
      rethrow;
    }
  }

  /// レシピのいいねを削除
  Future<bool> unlikeRecipe(int recipeId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('recipe_likes')
          .delete()
          .eq('recipe_id', recipeId)
          .eq('user_id', userId);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error unliking recipe: $e');
      rethrow;
    }
  }

  /// いいねの状態を切り替え
  Future<bool> toggleLike(int recipeId, bool currentlyLiked) async {
    if (currentlyLiked) {
      return await unlikeRecipe(recipeId);
    } else {
      return await likeRecipe(recipeId);
    }
  }

  /// 特定のレシピのいいね数を取得
  Future<int> getLikeCount(int recipeId) async {
    try {
      final response = await _supabase
          .rpc('get_recipe_like_count', params: {'recipe_id_param': recipeId});

      return response as int? ?? 0;
    } catch (e) {
      debugPrint('Error getting like count: $e');
      return 0;
    }
  }

  /// 現在のユーザーが特定のレシピにいいねしているかチェック
  Future<bool> hasUserLikedRecipe(int recipeId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await _supabase.rpc('has_user_liked_recipe', params: {
        'recipe_id_param': recipeId,
        'user_id_param': userId,
      });

      return response as bool? ?? false;
    } catch (e) {
      debugPrint('Error checking if user liked recipe: $e');
      return false;
    }
  }
}
