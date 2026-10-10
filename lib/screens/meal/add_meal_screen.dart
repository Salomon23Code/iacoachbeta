import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/meal.dart';
import '../../providers/meal_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final ImagePicker _picker = ImagePicker();

  MealType _selectedType = MealType.breakfast;

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _caloriesController = TextEditingController();

  String? _imagePath;

  bool _isPickingImage = false;

  // =========================================================
  // PHOTO APPAREIL
  // =========================================================

  Future<void> _takePhoto() async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (!mounted) return;

      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo ajoutée avec succès')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible d’ouvrir l’appareil photo : $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  // =========================================================
  // GALERIE
  // =========================================================

  Future<void> _selectFromGallery() async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (!mounted) return;

      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo sélectionnée avec succès')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible d’ouvrir la galerie : $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  // =========================================================
  // ENREGISTRER
  // =========================================================

  Future<void> _saveMeal() async {
    final description = _descriptionController.text.trim();

    final calories = double.tryParse(_caloriesController.text.trim());

    if (description.isEmpty) {
      _showMessage('Ajoute une description du repas.');
      return;
    }

    if (calories == null || calories < 0) {
      _showMessage('Entre un nombre de calories valide.');
      return;
    }

    final user = context.read<UserProvider>().currentUser;
    if (user == null) {
      _showMessage('Utilisateur introuvable. Reconnectez-vous.');
      return;
    }

    final saved = await context.read<MealProvider>().addMeal(
      userId: user.id,
      type: _selectedType,
      description: description,
      calories: calories,
      imagePath: _imagePath,
    );

    if (!mounted) return;
    if (!saved) {
      final error = context.read<MealProvider>().error;
      _showMessage(error ?? 'Impossible d’enregistrer le repas.');
      return;
    }

    Navigator.pop(context);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _caloriesController.dispose();

    super.dispose();
  }

  // =========================================================
  // UI
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(title: const Text('Ajouter un repas')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Quel repas ?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            _buildMealTypeSelector(),

            const SizedBox(height: 25),

            const Text(
              'Description du repas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _descriptionController,
              maxLines: 4,

              decoration: InputDecoration(
                hintText: 'Ex : poulet grillé, salade, riz...',
                filled: true,
                fillColor: Colors.grey.shade50,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Nombre de calories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _caloriesController,

              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),

              decoration: InputDecoration(
                hintText: 'Ex : 550',
                suffixText: 'kcal',
                filled: true,
                fillColor: Colors.grey.shade50,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Photo du repas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            _buildImagePreview(),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isPickingImage ? null : _takePhoto,

                    icon: const Icon(Icons.camera_alt_outlined),

                    label: const Text('Appareil photo'),

                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isPickingImage ? null : _selectFromGallery,

                    icon: const Icon(Icons.photo_library_outlined),

                    label: const Text('Galerie'),

                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            PrimaryButton(text: 'Enregistrer le repas', onPressed: _saveMeal),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SELECTEUR TYPE REPAS
  // =========================================================

  Widget _buildMealTypeSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,

      children: MealType.values.map((type) {
        final selected = _selectedType == type;

        return ChoiceChip(
          label: Text(_getMealLabel(type)),

          selected: selected,

          selectedColor: AppTheme.primary.withOpacity(.15),

          labelStyle: TextStyle(
            color: selected ? AppTheme.primary : Colors.black87,

            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),

          onSelected: (_) {
            setState(() {
              _selectedType = type;
            });
          },
        );
      }).toList(),
    );
  }

  // =========================================================
  // PREVIEW PHOTO
  // =========================================================

  Widget _buildImagePreview() {
    if (_imagePath == null) {
      return Container(
        width: double.infinity,
        height: 200,

        decoration: BoxDecoration(
          color: Colors.grey.shade100,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: Colors.grey.shade300),
        ),

        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(Icons.restaurant, size: 55, color: Colors.grey),

            SizedBox(height: 10),

            Text(
              'Aucune photo sélectionnée',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),

      child: Image.file(
        File(_imagePath!),

        width: double.infinity,
        height: 250,

        fit: BoxFit.cover,
      ),
    );
  }

  String _getMealLabel(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return 'Petit déjeuner';

      case MealType.lunch:
        return 'Déjeuner';

      case MealType.dinner:
        return 'Dîner';

      case MealType.snack:
        return 'Collation';
    }
  }
}
