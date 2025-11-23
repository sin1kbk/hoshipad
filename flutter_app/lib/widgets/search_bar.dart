import 'package:flutter/material.dart';
import '../models/recipe.dart';

class SearchBar extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final RecipeSource? sourceFilter;
  final ValueChanged<RecipeSource?> onSourceChanged;
  final RecipeCategory? categoryFilter;
  final ValueChanged<RecipeCategory?> onCategoryChanged;

  const SearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.sourceFilter,
    required this.onSourceChanged,
    required this.categoryFilter,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'レシピを検索...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<RecipeSource?>(
                initialValue: sourceFilter,
                decoration: const InputDecoration(
                  labelText: 'ソース',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [
                  const DropdownMenuItem<RecipeSource?>(
                    value: null,
                    child: Text('すべて'),
                  ),
                  ...RecipeSource.values.map(
                    (source) => DropdownMenuItem<RecipeSource>(
                      value: source,
                      child: Text(source.displayName),
                    ),
                  ),
                ],
                onChanged: onSourceChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<RecipeCategory?>(
                initialValue: categoryFilter,
                decoration: const InputDecoration(
                  labelText: 'カテゴリー',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [
                  const DropdownMenuItem<RecipeCategory?>(
                    value: null,
                    child: Text('すべて'),
                  ),
                  ...RecipeCategory.values.map(
                    (category) => DropdownMenuItem<RecipeCategory>(
                      value: category,
                      child: Text(category.displayName),
                    ),
                  ),
                ],
                onChanged: onCategoryChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
