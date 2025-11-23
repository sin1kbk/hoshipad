import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_bar.dart' as app;
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showCategories = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<RecipeProvider>().loadRecipes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.restaurant_menu, color: Color(0xFF6366F1)),
            const SizedBox(width: 8),
            Text(
              'hoshipad',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed: () => context.push('/add'),
              icon: const Icon(Icons.add),
              label: const Text('レシピを追加'),
            ),
          ),
        ],
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: app.SearchBar(
                    searchQuery: provider.searchQuery,
                    onSearchChanged: (query) {
                      provider.setSearchQuery(query);
                      setState(() => _showCategories = false);
                    },
                    sourceFilter: provider.sourceFilter,
                    onSourceChanged: provider.setSourceFilter,
                    categoryFilter: provider.categoryFilter,
                    onCategoryChanged: (category) {
                      provider.setCategoryFilter(category);
                      setState(() => _showCategories = false);
                    },
                  ),
                ),
                if (_showCategories &&
                    provider.categoryFilter == null &&
                    provider.searchQuery.isEmpty) ...[
                  _buildCategoryGrid(context, provider),
                ] else ...[
                  _buildRecipeGrid(context, provider),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, RecipeProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'カテゴリーから探す',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: RecipeCategory.values.map((category) {
              return _CategoryCard(
                category: category,
                onTap: () {
                  provider.setCategoryFilter(category);
                  setState(() => _showCategories = false);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeGrid(BuildContext context, RecipeProvider provider) {
    if (provider.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error != null) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'エラー: ${provider.error}',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }

    if (provider.recipes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: Text('レシピが見つかりませんでした')),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (provider.categoryFilter != null) ...[
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    provider.setCategoryFilter(null);
                    setState(() => _showCategories = true);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('カテゴリー一覧に戻る'),
                ),
                const SizedBox(width: 16),
                Text(
                  provider.categoryFilter!.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 1024
                  ? 4
                  : MediaQuery.of(context).size.width > 768
                      ? 3
                      : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: provider.recipes.length,
            itemBuilder: (context, index) {
              final recipe = provider.recipes[index];
              return RecipeCard(
                recipe: recipe,
                onDelete: () => _deleteRecipe(context, recipe),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRecipe(BuildContext context, Recipe recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('レシピを削除'),
        content: Text('「${recipe.title}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('削除'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await context.read<RecipeProvider>().deleteRecipe(recipe.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('レシピを削除しました')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('エラー: $e')),
          );
        }
      }
    }
  }
}

class _CategoryCard extends StatelessWidget {
  final RecipeCategory category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getCategoryIcon(category),
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                category.displayName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(RecipeCategory category) {
    switch (category) {
      case RecipeCategory.meat:
        return Icons.set_meal;
      case RecipeCategory.seafood:
        return Icons.set_meal;
      case RecipeCategory.vegetable:
      case RecipeCategory.salad:
        return Icons.eco;
      case RecipeCategory.rice:
        return Icons.rice_bowl;
      case RecipeCategory.noodle:
        return Icons.ramen_dining;
      case RecipeCategory.soup:
        return Icons.soup_kitchen;
      case RecipeCategory.sweets:
      case RecipeCategory.dessert:
        return Icons.cake;
      case RecipeCategory.bread:
        return Icons.bakery_dining;
      case RecipeCategory.bento:
        return Icons.lunch_dining;
      case RecipeCategory.other:
        return Icons.restaurant;
    }
  }
}
