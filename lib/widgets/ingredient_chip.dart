import 'package:flutter/material.dart';
import '../models/ingredient.dart';

class IngredientChip extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const IngredientChip({
    super.key,
    required this.ingredient,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        avatar: ingredient.emoji != null
            ? Text(
                ingredient.emoji!,
                style: const TextStyle(fontSize: 18),
              )
            : null,
        label: Text(
          ingredient.name,
          style: const TextStyle(fontSize: 14),
        ),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: onDelete,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        deleteIconColor: Theme.of(context).colorScheme.onPrimaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }
}
