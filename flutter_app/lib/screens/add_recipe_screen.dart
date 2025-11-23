import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _notesController = TextEditingController();

  RecipeSource _selectedSource = RecipeSource.youtube;
  RecipeCategory _selectedCategory = RecipeCategory.meat;

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _imageUrlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新しいレシピを追加'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '新しいレシピを追加',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'レシピのタイトル',
                          hintText: 'レシピのタイトルを入力',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'タイトルを入力してください';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _urlController,
                        decoration: const InputDecoration(
                          labelText: 'レシピのURL',
                          hintText: 'レシピのURLを入力',
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
                          hintText: '画像のURLを入力',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '画像URLを入力してください';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<RecipeSource>(
                        initialValue: _selectedSource,
                        decoration: const InputDecoration(
                          labelText: 'ソース',
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
                      const SizedBox(height: 16),
                      DropdownButtonFormField<RecipeCategory>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: '料理のカテゴリー',
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'メモ',
                          hintText: 'レシピについてのメモを追加',
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => context.pop(),
                            child: const Text('キャンセル'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _saveRecipe,
                            child: const Text('保存'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
    );

    try {
      await context.read<RecipeProvider>().createRecipe(recipe);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('レシピが正常に追加されました！')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('レシピの追加に失敗しました: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
