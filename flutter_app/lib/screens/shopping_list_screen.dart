import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_list_provider.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<ShoppingListProvider>().loadData(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('買い物リスト'),
      ),
      body: Consumer<ShoppingListProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: '買うものを入力...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onSubmitted: (value) => _addItem(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _addItem(context),
                      icon: const Icon(Icons.add_circle, color: Color(0xFFFF7400), size: 32),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: provider.shoppingList.isEmpty
                    ? const Center(
                        child: Text('買い物リストは空です', style: TextStyle(color: Colors.grey)),
                      )
                    : ListView.separated(
                        itemCount: provider.shoppingList.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = provider.shoppingList[index];
                          return CheckboxListTile(
                            title: Text(
                              item.name,
                              style: TextStyle(
                                decoration: item.isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: item.isChecked ? Colors.grey : Colors.black,
                              ),
                            ),
                            value: item.isChecked,
                            onChanged: (value) {
                              provider.toggleItem(item.id);
                            },
                            secondary: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.grey),
                              onPressed: () {
                                provider.deleteItem(item.id);
                              },
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addItem(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ShoppingListProvider>().addItem(text);
      _controller.clear();
    }
  }
}
