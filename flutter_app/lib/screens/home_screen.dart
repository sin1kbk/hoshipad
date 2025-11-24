import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/hoshipad_logo.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          children: [
            const HoshipadLogo(size: 32),
            const SizedBox(width: 8),
            Text(
              'hoshipad',
              style: GoogleFonts.poppins(
                color: const Color(0xFFFF7400),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.grey),
              onPressed: () {},
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: '料理名・食材で検索',
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (value) {
                context.read<RecipeProvider>().setSearchQuery(value);
              },
            ),
          ),
        ),
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadRecipes(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryList(context, provider),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, '保存されたレシピ'),
                  const SizedBox(height: 16),
                  if (provider.recipes.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('レシピが見つかりませんでした'),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.recipes.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final recipe = provider.recipes[index];
                        return RecipeCard(
                          recipe: recipe,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailScreen(recipe: recipe),
                              ),
                            );
                          },
                          onDelete: () => _deleteRecipe(context, recipe),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final authProvider = context.read<AuthProvider>();
          if (authProvider.isAuthenticated) {
            context.push('/add');
          } else {
            // 未認証の場合はログイン画面に誘導
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('ログインが必要です'),
                content: const Text('レシピを追加するにはログインが必要です。'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('キャンセル'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.push('/login');
                    },
                    child: const Text('ログイン'),
                  ),
                ],
              ),
            );
          }
        },
        backgroundColor: const Color(0xFFFF7400),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, RecipeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'カテゴリーから探す',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 90, // Slightly adjusted height
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: RecipeCategory.values.length,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              final category = RecipeCategory.values[index];
              final isSelected = provider.categoryFilter == category;
              return _CategoryItem(
                category: category,
                isSelected: isSelected,
                onTap: () {
                  if (isSelected) {
                    provider.setCategoryFilter(null);
                  } else {
                    provider.setCategoryFilter(category);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
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

class _CategoryItem extends StatelessWidget {
  final RecipeCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primary : Colors.orange[50],
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: colorScheme.primary, width: 2)
                  : null,
            ),
            child: category == RecipeCategory.meat
                ? Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Image.asset(
                      'assets/icons/meat.png',
                      color: isSelected ? Colors.white : const Color(0xFFFF7400),
                    ),
                  )
                : Icon(
                    _getCategoryIcon(category),
                    color: isSelected ? Colors.white : const Color(0xFFFF7400),
                    size: 32,
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            category.displayName,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? colorScheme.primary : Colors.grey[700],
            ),
          ),
        ],
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
