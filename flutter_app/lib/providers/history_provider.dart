import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/local_storage_service.dart';
import '../services/api_service.dart';

class HistoryProvider with ChangeNotifier {
  final LocalStorageService _localStorageService;
  final ApiService _apiService;

  HistoryProvider(this._localStorageService, this._apiService);

  List<Recipe> _recentRecipes = [];
  bool _isLoading = false;

  List<Recipe> get recentRecipes => _recentRecipes;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadRecentRecipes();
    } catch (e) {
      debugPrint('Error loading history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadRecentRecipes() async {
    final ids = await _localStorageService.getRecentRecipeIds();
    if (ids.isEmpty) {
      _recentRecipes = [];
      return;
    }

    final allRecipes = await _apiService.getAllRecipes();
    _recentRecipes = ids
        .map((id) => allRecipes.firstWhere(
              (r) => r.id == id,
              orElse: () => allRecipes.first, // Fallback
            ))
        .where((r) => ids.contains(r.id))
        .toList();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _localStorageService.addRecentRecipeId(recipe.id);
    await _loadRecentRecipes();
    notifyListeners();
  }
}
