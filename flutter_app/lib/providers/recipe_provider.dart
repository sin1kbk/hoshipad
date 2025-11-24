import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';

class RecipeProvider with ChangeNotifier {
  final ApiService _apiService;

  RecipeProvider(this._apiService);

  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String? _error;

  String _searchQuery = '';
  RecipeSource? _sourceFilter;
  String? _tagFilter;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  RecipeSource? get sourceFilter => _sourceFilter;
  String? get tagFilter => _tagFilter;

  Future<void> loadRecipes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _recipes = await _apiService.searchRecipes(
        query: _searchQuery.isEmpty ? null : _searchQuery,
        source: _sourceFilter,
        tag: _tagFilter,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadRecipes();
  }

  void setSourceFilter(RecipeSource? source) {
    _sourceFilter = source;
    loadRecipes();
  }

  void setTagFilter(String? tag) {
    _tagFilter = tag;
    loadRecipes();
  }

  void clearFilters() {
    _searchQuery = '';
    _sourceFilter = null;
    _tagFilter = null;
    loadRecipes();
  }

  Future<void> createRecipe(InsertRecipe recipe) async {
    try {
      await _apiService.createRecipe(recipe);
      await loadRecipes();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateRecipe(int id, InsertRecipe recipe) async {
    try {
      await _apiService.updateRecipe(id, recipe);
      await loadRecipes();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteRecipe(int id) async {
    try {
      await _apiService.deleteRecipe(id);
      await loadRecipes();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
