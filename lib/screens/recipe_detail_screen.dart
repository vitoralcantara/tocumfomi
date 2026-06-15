import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../state/app_state.dart';

class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
    final ingredients = ref.watch(availableIngredientsProvider);
    final favoriteRecipes = ref.watch(favoriteRecipesProvider);
    final isFavorite = favoriteRecipes.contains(recipe.id);

    final ingredientNames = ingredients.map((ing) => ing.name).toList();
    final matchScore = recipe.calculateMatchScore(ingredientNames);
    final missingIngredients = recipe.ingredients
        .where((ing) => !ingredientNames.any(
              (available) => ing.toLowerCase().contains(available.toLowerCase()),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('recipe_detail.title'.tr()),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              ref.read(favoriteRecipesProvider.notifier).toggleFavorite(recipe.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.imageUrl != null)
              CachedNetworkImage(
                imageUrl: recipe.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.restaurant, size: 50),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and basic info
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Meta info
                  Row(
                    children: [
                      _buildInfoChip(
                        context,
                        Icons.access_time,
                        '${recipe.prepTime} min',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        context,
                        Icons.signal_cellular_alt,
                        recipe.difficulty,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        context,
                        Icons.restaurant,
                        recipe.cuisine,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Match score
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getMatchColor(context, matchScore, recipe.ingredients.length),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'home.available_ingredients'.tr(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$matchScore de ${recipe.ingredients.length} ${'recipe_detail.ingredients_available'.tr()}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: matchScore / recipe.ingredients.length,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ingredients section
                  _buildSectionTitle(context, 'recipe_detail.ingredients'.tr()),
                  const SizedBox(height: 12),
                  _buildIngredientsList(context, recipe.ingredients, ingredients),
                  const SizedBox(height: 24),

                  // Missing ingredients
                  if (missingIngredients.isNotEmpty) ...[
                    _buildSectionTitle(context, 'recipe_detail.missing_ingredients'.tr()),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shopping_cart, color: Colors.orange[700]),
                              const SizedBox(width: 8),
                              Text(
                                'recipe_detail.need_to_buy'.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[900],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...missingIngredients.map((ingredient) => Padding(
                                padding: const EdgeInsets.only(left: 32, top: 4),
                                child: Text(
                                  '• $ingredient',
                                  style: TextStyle(color: Colors.orange[900]),
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Instructions section
                  _buildSectionTitle(context, 'recipe_detail.instructions'.tr()),
                  const SizedBox(height: 12),
                  _buildInstructionsList(context, recipe.instructions),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildIngredientsList(
    BuildContext context,
    List<String> recipeIngredients,
    List<Ingredient> availableIngredients,
  ) {
    final availableIngredientNames = availableIngredients.map((ing) => ing.name).toList();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: recipeIngredients.map((ingredient) {
            final isAvailable = availableIngredientNames.any(
              (available) => ingredient.toLowerCase().contains(available.toLowerCase()),
            );
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    isAvailable ? Icons.check_circle : Icons.cancel,
                    color: isAvailable ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ingredient,
                      style: TextStyle(
                        color: isAvailable ? Colors.black87 : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInstructionsList(BuildContext context, List<String> instructions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: instructions.asMap().entries.map((entry) {
            final index = entry.key;
            final instruction = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      instruction,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getMatchColor(BuildContext context, int matchScore, int totalIngredients) {
    final percentage = matchScore / totalIngredients;
    if (percentage >= 0.8) {
      return Colors.green[100]!;
    } else if (percentage >= 0.5) {
      return Colors.orange[100]!;
    } else {
      return Colors.red[100]!;
    }
  }
}
