import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../providers/auth_provider.dart';
import '../services/cookpad_scraper_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AddRecipeScreen extends StatefulWidget {
  final Recipe? recipe;
  final String? sharedUrl;
  final String? prefilledTitle;
  final String? prefilledImageUrl;

  const AddRecipeScreen({
    super.key,
    this.recipe,
    this.sharedUrl,
    this.prefilledTitle,
    this.prefilledImageUrl,
  });

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _notesController = TextEditingController();
  final _scraperService = CookpadScraperService();

  RecipeSource _selectedSource = RecipeSource.youtube;
  RecipeCategory _selectedCategory = RecipeCategory.meat;
  List<Ingredient> _ingredients = [];
  bool _isLoadingMetadata = false;
  bool _hasTriedAutoFetch = false; // 自動取得を一度だけ実行するフラグ

  @override
  void initState() {
    super.initState();

    // 共有されたURLがある場合は自動設定
    if (widget.sharedUrl != null) {
      _urlController.text = widget.sharedUrl!;
      debugPrint('Shared URL set to form: ${widget.sharedUrl}');
    }

    // 事前入力されたタイトルがある場合は自動設定
    if (widget.prefilledTitle != null && widget.prefilledTitle!.isNotEmpty) {
      _titleController.text = widget.prefilledTitle!;
      debugPrint('Prefilled title set to form: ${widget.prefilledTitle}');
    }

    // 事前入力された画像URLがある場合は自動設定
    if (widget.prefilledImageUrl != null && widget.prefilledImageUrl!.isNotEmpty) {
      _imageUrlController.text = widget.prefilledImageUrl!;
      debugPrint('Prefilled image URL set to form: ${widget.prefilledImageUrl}');
    }

    // 編集モードの場合は既存のレシピデータを設定
    if (widget.recipe != null) {
      final recipe = widget.recipe!;
      _titleController.text = recipe.title;
      _urlController.text = recipe.url;
      _imageUrlController.text = recipe.imageUrl;
      if (recipe.notes != null) {
        _notesController.text = recipe.notes!;
      }
      _selectedSource = recipe.source;
      _selectedCategory = recipe.category;
      _ingredients = recipe.ingredients ?? [];
    }

    _imageUrlController.addListener(_onImageUrlChanged);
  }

  void _onImageUrlChanged() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 認証状態を確認して、認証済みかつまだ自動取得を実行していない場合に実行
    final authProvider = context.watch<AuthProvider>();
    final isAuthenticated = authProvider.isAuthenticated;

    if (isAuthenticated && !_hasTriedAutoFetch && widget.sharedUrl != null) {
      // CookpadのURLの場合
      if (widget.sharedUrl!.contains('cookpad.com')) {
        _selectedSource = RecipeSource.cookpad;
        _hasTriedAutoFetch = true; // フラグを立てて一度だけ実行

        // 画像URLが既に設定されている場合（ブックマークレットから渡された場合）は
        // スクレイピングをスキップ
        if (widget.prefilledImageUrl != null && widget.prefilledImageUrl!.isNotEmpty) {
          debugPrint('Image URL already provided, skipping scraping');
          // カテゴリだけ推定する場合はここで処理
          // 現在はブックマークレットから全ての情報が渡されているのでスキップ
        } else {
          // 画像URLが渡されていない場合のみスクレイピングを実行
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _autoFetchRecipeMetadata(widget.sharedUrl!);
            }
          });
        }
      }
    }
  }

  /// Cookpadから自動的にレシピメタデータを取得
  Future<void> _autoFetchRecipeMetadata(String url) async {
    setState(() {
      _isLoadingMetadata = true;
    });

    try {
      final metadata = await _scraperService.scrapeRecipe(url);

      if (metadata != null && mounted) {
        setState(() {
          // タイトルが空の場合のみ自動入力
          if (_titleController.text.isEmpty) {
            _titleController.text = metadata.title;
          }
          _imageUrlController.text = metadata.imageUrl;
          _ingredients = metadata.ingredients;
          if (metadata.suggestedCategory != null) {
            _selectedCategory = metadata.suggestedCategory!;
          }
          _isLoadingMetadata = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('レシピ情報を自動取得しました!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else if (mounted) {
        setState(() {
          _isLoadingMetadata = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('レシピ情報の取得に失敗しました'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMetadata = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_onImageUrlChanged);
    _titleController.dispose();
    _urlController.dispose();
    _imageUrlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isAuthenticated = authProvider.isAuthenticated;

    // 未認証の場合はログインを促す
    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('レシピを追加'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 24),
                const Text(
                  'ログインが必要です',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'レシピを追加・編集するには\nログインが必要です',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // 現在のURLとパラメータを保持
                    final state = GoRouterState.of(context);
                    final currentPath = state.uri.path;
                    final queryParams = state.uri.queryParameters;

                    // redirectパラメータを追加
                    final loginUri = Uri(
                      path: '/login',
                      queryParameters: {
                        'redirect': currentPath,
                        ...queryParams,
                      },
                    );
                    context.push(loginUri.toString());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ログイン',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    final state = GoRouterState.of(context);
                    final currentPath = state.uri.path;
                    final queryParams = state.uri.queryParameters;

                    final signupUri = Uri(
                      path: '/signup',
                      queryParameters: {
                        'redirect': currentPath,
                        ...queryParams,
                      },
                    );
                    context.push(signupUri.toString());
                  },
                  child: const Text(
                    'アカウントを作成',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 認証済みの場合は通常のフォームを表示
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe != null ? 'レシピを編集' : 'レシピを書く'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_isLoadingMetadata)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
            onPressed: _saveRecipe,
            child: const Text(
              '保存',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload Placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                clipBehavior: Clip.antiAlias,
                child: _imageUrlController.text.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: _imageUrlController.text,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text(
                              '画像の読み込みに失敗しました',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            '料理の写真を登録',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),

              _buildSectionLabel('レシピのタイトル'),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: '例：肉じゃが',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'タイトルを入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              _buildSectionLabel('レシピのURL (動画・記事など)'),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  hintText: 'https://...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'URLを入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: '画像のURL (一時的)',
                  hintText: 'https://...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '画像URLを入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('ソース'),
                        DropdownButtonFormField<RecipeSource>(
                          value: _selectedSource,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: RecipeSource.values.map((source) {
                            return DropdownMenuItem(
                              value: source,
                              child: Text(source.displayName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedSource = value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('カテゴリー'),
                        DropdownButtonFormField<RecipeCategory>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: RecipeCategory.values.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category.displayName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedCategory = value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 材料リスト
              if (_ingredients.isNotEmpty) ...[
                _buildSectionLabel('材料 (${_ingredients.length}品目)'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _ingredients.length,
                    separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
                    itemBuilder: (context, index) {
                      final ingredient = _ingredients[index];
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.circle, size: 8),
                        title: Text(ingredient.name),
                        trailing: Text(
                          ingredient.amount,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              _buildSectionLabel('メモ'),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'コツやポイントなどを入力',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final recipe = InsertRecipe(
      title: _titleController.text,
      url: _urlController.text,
      imageUrl: _imageUrlController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      source: _selectedSource,
      category: _selectedCategory,
      ingredients: _ingredients.isEmpty ? null : _ingredients,
    );

    try {
      if (widget.recipe != null) {
        await context.read<RecipeProvider>().updateRecipe(widget.recipe!.id, recipe);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('レシピが更新されました！')),
          );
          // スタックがある場合はpop、ない場合はホームにリダイレクト
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        }
      } else {
        await context.read<RecipeProvider>().createRecipe(recipe);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('レシピが正常に追加されました！')),
          );
          // スタックがある場合はpop、ない場合はホームにリダイレクト
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('レシピの保存に失敗しました: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
