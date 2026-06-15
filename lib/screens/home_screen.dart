import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/app_state.dart';
import '../widgets/ingredient_chip.dart';
import '../widgets/add_ingredient_dialog.dart';
import '../models/ingredient.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(availableIngredientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dicas de Comida'),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredientes Disponíveis',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione os ingredientes que você tem em casa',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            if (ingredients.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.kitchen_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum ingrediente adicionado',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toque no + para adicionar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ingredients.map((ingredient) {
                        return IngredientChip(
                          ingredient: ingredient,
                          onDelete: () {
                            ref
                                .read(availableIngredientsProvider.notifier)
                                .removeIngredient(ingredient.id);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    if (ingredients.length >= 2)
                      _buildGetRecipesButton(context, ref)
                    else
                      _buildMinimumInfo(context),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddIngredientDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
      ),
    );
  }

  Widget _buildGetRecipesButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/recipes');
        },
        icon: const Icon(Icons.restaurant_menu),
        label: const Text('Ver Sugestões de Receitas'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildMinimumInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Adicione pelo menos 2 ingredientes para ver sugestões',
              style: TextStyle(color: Colors.orange[900]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddIngredientDialog(BuildContext context, WidgetRef ref) async {
    final ingredients = ref.read(availableIngredientsProvider);
    
    final result = await showDialog<List<Ingredient>>(
      context: context,
      builder: (context) => AddIngredientDialog(
        existingIngredients: ingredients,
      ),
    );

    if (result != null && result.isNotEmpty) {
      for (final ingredient in result) {
        await ref.read(availableIngredientsProvider.notifier).addIngredient(ingredient);
      }
    }
  }
}
