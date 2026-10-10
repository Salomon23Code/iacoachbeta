import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/shopping_items.dart';
import '../../providers/shopping_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shopping_category.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final user = context.read<UserProvider>().currentUser;
      if (user != null) {
        context.read<ShoppingProvider>().loadItems(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<ShoppingProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF8FAF8),
      appBar: AppBar(
        title: const Text('Mes courses'),
        actions: [
          IconButton(
            tooltip: 'Réinitialiser',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.clearChecked();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppTheme.primary,
                  AppTheme.darkGreen,
                ],
              ),
              borderRadius:
              BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 35,
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ma liste de courses',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        '${provider.checkedCount} article(s) sélectionné(s)',
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          ShoppingCategoryWidget(
            category: ShoppingCategory.proteins,
            title: 'Protéines',
            icon: Icons.egg_alt,
          ),

          ShoppingCategoryWidget(
            category: ShoppingCategory.vegetables,
            title: 'Légumes',
            icon: Icons.eco,
          ),

          ShoppingCategoryWidget(
            category: ShoppingCategory.essentials,
            title: 'Essentiels',
            icon: Icons.shopping_basket,
          ),
        ],
      ),
    );
  }
}