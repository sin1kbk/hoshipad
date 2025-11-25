import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../providers/auth_provider.dart';
import '../services/cookpad_scraper_service.dart';
import '../services/cookpad_scraper_service.dart';
import '../widgets/platform_image.dart';

class AddRecipeScreen extends StatefulWidget {
  final Recipe? recipe;
  final String? sharedUrl;
  final String? prefilledTitle;
  final String? prefilledImageUrl;
  final String? prefilledIngredients;

  const AddRecipeScreen({
    super.key,
    this.recipe,
    this.sharedUrl,
    this.prefilledTitle,
    this.prefilledImageUrl,
    this.prefilledIngredients,
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
  final _tagInputController = TextEditingController();
  final _scraperService = CookpadScraperService();

  RecipeSource _selectedSource = RecipeSource.youtube;
  List<String> _selectedTags = [];

  // 材料のコントローラーリスト
  final List<({TextEditingController name, TextEditingController amount})> _ingredientControllers = [];

  bool _isLoadingMetadata = false;
  bool _hasTriedAutoFetch = false;

  @override
  void initState() {
    super.initState();

    // 認証チェック
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final authProvider = context.read<AuthProvider>();

      // 未認証チェック
      if (!authProvider.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('レシピを追加・編集するにはログインが必要です'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
        context.go('/login');
        return;
      }

      // 編集モードの場合、作成者チェック
      if (widget.recipe != null) {
        final currentUserId = authProvider.currentUser?.id;
        final recipeUserId = widget.recipe!.userId;

        if (currentUserId != recipeUserId) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('自分が作成したレシピのみ編集できます'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.of(context).pop();
          return;
        }
      }
    });

    // Shared URLが提供されている場合
    if (widget.sharedUrl != null) {
      debugPrint('=== AddRecipeScreen initState ===');
      debugPrint('Shared URL: ${widget.sharedUrl}');
      _urlController.text = widget.sharedUrl!;

      // URLからソースを自動判定
      if (widget.sharedUrl!.contains('instagram.com')) {
        debugPrint('Setting source to Instagram');
        _selectedSource = RecipeSource.instagram;
      } else if (widget.sharedUrl!.contains('cookpad.com')) {
        debugPrint('Setting source to Cookpad');
        _selectedSource = RecipeSource.cookpad;
      } else if (widget.sharedUrl!.contains('youtube.com') || widget.sharedUrl!.contains('youtu.be')) {
        debugPrint('Setting source to YouTube');
        _selectedSource = RecipeSource.youtube;
      } else if (widget.sharedUrl!.contains('twitter.com') || widget.sharedUrl!.contains('x.com')) {
        debugPrint('Setting source to Twitter');
        _selectedSource = RecipeSource.twitter;
      }
      debugPrint('Selected source after URL check: $_selectedSource');
    } else {
      debugPrint('=== AddRecipeScreen initState: No shared URL ===');
    }

    // プレフィルされた値をセット
    if (widget.prefilledTitle != null) {
      _titleController.text = widget.prefilledTitle!;
    }
    if (widget.prefilledImageUrl != null) {
      _imageUrlController.text = widget.prefilledImageUrl!;
    }

    // 初期材料の取得
    List<Ingredient> initialIngredients = [];
    if (widget.prefilledIngredients != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(widget.prefilledIngredients!);
        initialIngredients = jsonList.map((json) => Ingredient.fromJson(json)).toList();
      } catch (e) {
        debugPrint('Failed to parse prefilled ingredients: $e');
      }
    } else if (widget.recipe != null) {
      initialIngredients = widget.recipe!.ingredients ?? [];
    }

    // コントローラーの初期化
    for (var ingredient in initialIngredients) {
      _addIngredientRow(ingredient.name, ingredient.amount);
    }
    // 材料が空の場合は1行追加しておく
    if (_ingredientControllers.isEmpty) {
      _addIngredientRow();
    }

    // 既存のレシピがある場合（編集モード）
    if (widget.recipe != null) {
      final recipe = widget.recipe!;
      _titleController.text = recipe.title;
      _urlController.text = recipe.url;
      _imageUrlController.text = recipe.imageUrl;
      if (recipe.notes != null) {
        _notesController.text = recipe.notes!;
      }
      if (recipe.tags != null) {
        _selectedTags = List.from(recipe.tags!);
      }
      _selectedSource = recipe.source;
    }

    _imageUrlController.addListener(_onImageUrlChanged);
  }

  void _addIngredientRow([String name = '', String amount = '']) {
    _ingredientControllers.add((
      name: TextEditingController(text: name),
      amount: TextEditingController(text: amount),
    ));
  }

  void _removeIngredientRow(int index) {
    final controllers = _ingredientControllers.removeAt(index);
    controllers.name.dispose();
    controllers.amount.dispose();
    setState(() {});
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty && !_selectedTags.contains(trimmedTag)) {
      setState(() {
        _selectedTags.add(trimmedTag);
        _tagInputController.clear();
      });
    }
  }

  void _onImageUrlChanged() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authProvider = context.watch<AuthProvider>();
    final isAuthenticated = authProvider.isAuthenticated;

    if (isAuthenticated && !_hasTriedAutoFetch && widget.sharedUrl != null) {
      if (widget.sharedUrl!.contains('instagram.com')) {
        _selectedSource = RecipeSource.instagram;
        _hasTriedAutoFetch = true;
      } else if (widget.sharedUrl!.contains('cookpad.com')) {
        _selectedSource = RecipeSource.cookpad;
        _hasTriedAutoFetch = true;

        if (widget.prefilledImageUrl != null && widget.prefilledImageUrl!.isNotEmpty) {
          debugPrint('Image URL already provided, skipping scraping');
        } else if (_ingredientControllers.any((c) => c.name.text.isNotEmpty)) {
          debugPrint('Ingredients already provided, skipping scraping');
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _autoFetchRecipeMetadata(widget.sharedUrl!);
            }
          });
        }
      }
    }
  }

  Future<void> _autoFetchRecipeMetadata(String url) async {
    setState(() {
      _isLoadingMetadata = true;
    });

    try {
      final metadata = await _scraperService.scrapeRecipe(url);

      if (metadata != null && mounted) {
        setState(() {
          if (_titleController.text.isEmpty) {
            _titleController.text = metadata.title;
          }
          _imageUrlController.text = metadata.imageUrl;

          // 既存の材料をクリアして新しい材料を追加
          for (var controller in _ingredientControllers) {
            controller.name.dispose();
            controller.amount.dispose();
          }
          _ingredientControllers.clear();

          for (var ingredient in metadata.ingredients) {
            _addIngredientRow(ingredient.name, ingredient.amount);
          }
          if (_ingredientControllers.isEmpty) {
            _addIngredientRow();
          }

          if (metadata.suggestedCategory != null) {
            if (!_selectedTags.contains(metadata.suggestedCategory!)) {
              _selectedTags.add(metadata.suggestedCategory!);
            }
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
    _tagInputController.dispose();
    for (var controller in _ingredientControllers) {
      controller.name.dispose();
      controller.amount.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isAuthenticated = authProvider.isAuthenticated;

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
                    final state = GoRouterState.of(context);
                    final currentPath = state.uri.path;
                    final queryParams = state.uri.queryParameters;

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
                    ? PlatformImage(
                        imageUrl: _imageUrlController.text,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text(
                                '画像の読み込みに失敗しました',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          );
                        },
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
                  labelText: '画像のURL',
                  hintText: 'https://... (任意)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
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
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionLabel('タグ (任意)'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tagInputController,
                      decoration: const InputDecoration(
                        hintText: 'タグを入力',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.local_offer),
                      ),
                      onFieldSubmitted: (value) {
                        _addTag(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      _addTag(_tagInputController.text);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('追加'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_selectedTags.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedTags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          _selectedTags.remove(tag);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                'プリセットタグ:',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: RecipeCategory.values.map((category) {
                  final tagName = category.displayName;
                  final isSelected = _selectedTags.contains(tagName);
                  return FilterChip(
                    label: Text(tagName),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          if (!_selectedTags.contains(tagName)) {
                            _selectedTags.add(tagName);
                          }
                        } else {
                          _selectedTags.remove(tagName);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // 材料リスト編集
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionLabel('材料'),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _addIngredientRow();
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('行を追加'),
                  ),
                ],
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _ingredientControllers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final controllers = _ingredientControllers[index];
                  return Row(
                    children: [
                      const Icon(Icons.drag_handle, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: controllers.name,
                          decoration: const InputDecoration(
                            hintText: '材料名',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: controllers.amount,
                          decoration: const InputDecoration(
                            hintText: '分量',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => _removeIngredientRow(index),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

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

    // 材料リストの構築
    final List<Ingredient> ingredients = [];
    for (var controller in _ingredientControllers) {
      final name = controller.name.text.trim();
      final amount = controller.amount.text.trim();
      if (name.isNotEmpty) {
        ingredients.add(Ingredient(name: name, amount: amount));
      }
    }

    final recipe = InsertRecipe(
      title: _titleController.text,
      url: _urlController.text,
      imageUrl: _imageUrlController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      source: _selectedSource,
      tags: _selectedTags.isEmpty ? null : _selectedTags,
      ingredients: ingredients.isEmpty ? null : ingredients,
    );

    try {
      if (widget.recipe != null) {
        await context.read<RecipeProvider>().updateRecipe(widget.recipe!.id, recipe);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('レシピが更新されました！')),
          );
          // 編集画面を閉じる
          Navigator.of(context).pop();
          // RecipeDetailScreenも閉じてHomeScreenに戻る
          if (context.canPop()) {
            Navigator.of(context).pop();
          }
        }
      } else {
        await context.read<RecipeProvider>().createRecipe(recipe);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('レシピが正常に追加されました！')),
          );
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
