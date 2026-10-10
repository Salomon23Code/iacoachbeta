import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../models/shopping_items.dart';
import '../providers/shopping_provider.dart';
import '../theme/app_theme.dart';

class ShoppingCategoryWidget extends StatelessWidget {
  final ShoppingCategory category;
  final String title;
  final IconData icon;

  const ShoppingCategoryWidget({
    super.key,
    required this.category,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<ShoppingProvider>();

    final items =
    provider.itemsByCategory(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor:
                AppTheme.primary.withOpacity(.1),
                child: Icon(
                  icon,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(width: 12),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ...items.map(
                (item) => CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: item.checked,
              activeColor: AppTheme.primary,
              title: Text(item.name),
              onChanged: (_) {
                provider.toggleItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }
}