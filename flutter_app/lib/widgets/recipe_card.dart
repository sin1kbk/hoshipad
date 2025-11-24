import 'package:flutter/material.dart';
import 'platform_image.dart';
import '../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onLike;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: PlatformImage(
                    imageUrl: recipe.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[100],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[100],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: onLike,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            recipe.isLikedByCurrentUser ? Icons.favorite : Icons.favorite_border,
                            color: recipe.isLikedByCurrentUser ? Colors.pinkAccent : Colors.white,
                            size: 10,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${recipe.likeCount}',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.orange[100],
                          child: const Icon(Icons.person, size: 12, color: Colors.orange),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            recipe.source.displayName,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[700],
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // タグ表示
                    if (recipe.tags != null && recipe.tags!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          // 最大3つまで表示
                          ...recipe.tags!.take(3).map((tag) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.orange[200]!),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )),
                          // 3つ以上ある場合は "+N" を表示
                          if (recipe.tags!.length > 3)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '+${recipe.tags!.length - 3}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                    if (onEdit != null || onDelete != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (onEdit != null)
                            InkWell(
                              onTap: onEdit,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(Icons.edit_outlined, size: 18, color: Colors.grey[600]),
                              ),
                            ),
                          if (onDelete != null)
                            InkWell(
                              onTap: onDelete,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(Icons.delete_outline, size: 18, color: Colors.red[400]),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _buildChip removed as it's no longer used in this design
}
