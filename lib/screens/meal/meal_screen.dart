import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/meal.dart';
import '../../providers/meal_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/meal_card.dart';
import '../shopping/shopping_screen.dart';
import 'add_meal_screen.dart';


class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<MealProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mes repas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const ShoppingScreen(),
                ),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const AddMealScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: provider.meals.isEmpty
          ? const Center(
        child: Text(
          'Aucun repas enregistré.\n\n'
              'Ajoute ton premier repas.',
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.meals.length,
        itemBuilder: (_, index) {
          final meal =
          provider.meals[index];

          return MealCard(meal: meal);
        },
      ),
    );
  }
}