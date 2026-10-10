import 'dart:io';

import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../screens/meal/meal_details_screen.dart';
import '../theme/app_theme.dart';


class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  MealDetailScreen(meal: meal),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(15),
                  color:
                  AppTheme.primary.withOpacity(.1),
                ),
                child: meal.imagePath != null
                    ? ClipRRect(
                  borderRadius:
                  BorderRadius.circular(15),
                  child: Image.file(
                    File(meal.imagePath!),
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(
                  Icons.restaurant,
                  color: AppTheme.primary,
                  size: 35,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.typeLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      meal.description,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '${meal.calories.toStringAsFixed(0)} kcal',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}