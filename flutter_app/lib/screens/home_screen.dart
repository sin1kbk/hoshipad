import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/like_provider.dart';
import '../widgets/recipe_card.dart';
import '../widgets/hoshipad_logo.dart';
import 'recipe_detail_screen.dart';
import 'sharing_help_screen.dart';

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
        title: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return Row(
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
                  icon: const Icon(Icons.ios_share, color: Colors.grey),
                  tooltip: 'iOSで共有する方法',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SharingHelpScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Text('📌', style: TextStyle(fontSize: 24)),
                  tooltip: 'ブックマークレットを追加',
                  onPressed: () => _showBookmarkletDialog(context),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.grey),
                  onPressed: () {},
                ),
                // ログイン状態に応じたボタン/アイコンを表示
                if (authProvider.isAuthenticated)
                  _buildUserMenu(context, authProvider)
                else
                  _buildLoginButton(context),
              ],
            );
          },
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
      body: Consumer2<RecipeProvider, AuthProvider>(
        builder: (context, recipeProvider, authProvider, child) {
          if (recipeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentUserId = authProvider.currentUser?.id;

          return RefreshIndicator(
            onRefresh: () => recipeProvider.loadRecipes(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryList(context, recipeProvider),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, '保存されたレシピ'),
                  const SizedBox(height: 16),
                  if (recipeProvider.recipes.isEmpty)
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
                      itemCount: recipeProvider.recipes.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final recipe = recipeProvider.recipes[index];
                        final isCreator = currentUserId != null && recipe.userId == currentUserId;
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
                          onDelete: isCreator ? () => _deleteRecipe(context, recipe) : null,
                          onLike: () => _toggleLike(context, recipe),
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
          if (!authProvider.isAuthenticated) {
            // 未認証の場合はログイン画面にリダイレクト
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('レシピを追加するにはログインが必要です'),
                duration: Duration(seconds: 2),
              ),
            );
            context.go('/login');
            return;
          }

          // 認証済みの場合はレシピ追加画面を開く
          context.go('/add');
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
              final isSelected = provider.tagFilter == category.displayName;
              return _CategoryItem(
                category: category,
                isSelected: isSelected,
                onTap: () {
                  if (isSelected) {
                    provider.setTagFilter(null);
                  } else {
                    provider.setTagFilter(category.displayName);
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

  Future<void> _toggleLike(BuildContext context, Recipe recipe) async {
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('いいねするにはログインが必要です')),
      );
      return;
    }

    try {
      final likeProvider = context.read<LikeProvider>();
      await likeProvider.toggleLike(recipe.id, recipe.isLikedByCurrentUser);

      // レシピリストを再読み込み
      if (context.mounted) {
        await context.read<RecipeProvider>().loadRecipes();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
    }
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

  // ログインボタンを構築
  Widget _buildLoginButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF7400), Color(0xFFFF9500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7400).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/login'),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Text(
              'ログイン',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ユーザーメニューを構築
  Widget _buildUserMenu(BuildContext context, AuthProvider authProvider) {
    final userProfile = authProvider.currentUserProfile;
    final avatarUrl = userProfile?.avatarUrl;
    final displayName = userProfile?.displayName ?? 'ユーザー';
    final userEmail = authProvider.currentUser?.email ?? '';

    return PopupMenuButton<String>(
      offset: const Offset(-20, 55),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      padding: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF7400).withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFFF7400),
          backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
              ? CachedNetworkImageProvider(avatarUrl)
              : null,
          child: avatarUrl == null || avatarUrl.isEmpty
              ? Text(
                  displayName.isNotEmpty
                      ? displayName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                )
              : null,
        ),
      ),
      onSelected: (String value) async {
        if (value == 'profile') {
          context.go('/profile-edit');
        } else if (value == 'signout') {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Text(
                'サインアウト',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: const Text(
                'サインアウトしますか？',
                style: TextStyle(fontSize: 15),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'キャンセル',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF7400), Color(0xFFFF9500)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF7400).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'サインアウト',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );

          if (confirmed == true && context.mounted) {
            await authProvider.signOut();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('サインアウトしました'),
                  backgroundColor: const Color(0xFFFF7400),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
              context.go('/');
            }
          }
        }
      },
      itemBuilder: (BuildContext context) => [
        // ユーザー情報ヘッダー
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFFF7400),
                  backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                      ? CachedNetworkImageProvider(avatarUrl)
                      : null,
                  child: avatarUrl == null || avatarUrl.isEmpty
                      ? Text(
                          displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        // プロフィールメニュー
        PopupMenuItem<String>(
          value: 'profile',
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7400).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Color(0xFFFF7400),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'プロフィール',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 18,
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        // サインアウトメニュー
        PopupMenuItem<String>(
          value: 'signout',
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'サインアウト',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }





  void _showBookmarkletDialog(BuildContext context) {
    if (kIsWeb) {
      // Web環境では専用のブックマークレットページを開く
      final uri = Uri.parse('/bookmarklet.html');
      launchUrl(uri, webOnlyWindowName: '_blank');
    } else {
      // モバイル環境では説明ダイアログを表示
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              const Text('📌', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              const Text('ブックマークレット'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Safariでレシピページを見ている時に、ブックマークレットから簡単にhoshipadに保存できます！',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'インストール方法',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('1. Webブラウザでhoshipadを開く'),
                const SizedBox(height: 4),
                const Text('2. ブックマークレットページにアクセス'),
                const SizedBox(height: 4),
                const Text('3. 「📌 hoshipadに保存」ボタンを長押し'),
                const SizedBox(height: 4),
                const Text('4. 「ブックマークに追加」を選択'),
                const SizedBox(height: 4),
                const Text('5. 保存先を「お気に入り」に設定'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFF7400), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline, color: Color(0xFFFF7400)),
                          const SizedBox(width: 8),
                          const Text(
                            'アクセス方法',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF7400),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('hoshipad.com/bookmarklet.html'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('閉じる'),
            ),
          ],
        ),
      );
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
