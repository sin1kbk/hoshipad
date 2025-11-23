import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/shopping_item.dart';
import '../services/local_storage_service.dart';

class ShoppingListProvider with ChangeNotifier {
  final LocalStorageService _localStorageService;

  ShoppingListProvider(this._localStorageService);

  List<ShoppingItem> _shoppingList = [];
  bool _isLoading = false;

  List<ShoppingItem> get shoppingList => _shoppingList;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _shoppingList = await _localStorageService.getShoppingList();
    } catch (e) {
      debugPrint('Error loading shopping list: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(String name) async {
    final newItem = ShoppingItem(
      id: const Uuid().v4(),
      name: name,
    );
    _shoppingList.add(newItem);
    await _localStorageService.saveShoppingList(_shoppingList);
    notifyListeners();
  }

  Future<void> toggleItem(String id) async {
    final index = _shoppingList.indexWhere((item) => item.id == id);
    if (index != -1) {
      _shoppingList[index] = _shoppingList[index].copyWith(
        isChecked: !_shoppingList[index].isChecked,
      );
      await _localStorageService.saveShoppingList(_shoppingList);
      notifyListeners();
    }
  }

  Future<void> deleteItem(String id) async {
    _shoppingList.removeWhere((item) => item.id == id);
    await _localStorageService.saveShoppingList(_shoppingList);
    notifyListeners();
  }
}
