import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shopping_item.dart';

class LocalStorageService {
  static const String _shoppingListKey = 'shopping_list';
  static const String _recentRecipesKey = 'recent_recipes';

  Future<List<ShoppingItem>> getShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_shoppingListKey);
    if (jsonString == null) {
      return [];
    }
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => ShoppingItem.fromJson(json)).toList();
  }

  Future<void> saveShoppingList(List<ShoppingItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_shoppingListKey, jsonString);
  }

  Future<List<int>> getRecentRecipeIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stringList = prefs.getStringList(_recentRecipesKey);
    if (stringList == null) {
      return [];
    }
    return stringList.map((e) => int.parse(e)).toList();
  }

  Future<void> addRecentRecipeId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentList = prefs.getStringList(_recentRecipesKey) ?? [];

    // Remove if exists to move to top
    currentList.remove(id.toString());

    // Add to beginning
    currentList.insert(0, id.toString());

    // Limit to 10 items
    if (currentList.length > 10) {
      currentList = currentList.sublist(0, 10);
    }

    await prefs.setStringList(_recentRecipesKey, currentList);
  }
}
