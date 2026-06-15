import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../state/app_state.dart';
import '../widgets/recipe_card.dart';

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(availableIngredientsProvider);
    final recipesAsync = ref.watch(recipesProvider);
    final favoriteRecipes = ref.watch(favoriteRecipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugestões de Receitas'),
        elevation: 2,
      ),
      body: ingredients.isEmpty
          ? _buildEmptyState(context)
          : recipesAsync.when(
              data: (recipes) {
                if (recipes.isEmpty) {
                  return _buildNoRecipesState(context, ingredients);
                }
                return _buildRecipesList(
                  context,
                  recipes,
                  ingredients,
                  favoriteRecipes,
                  ref,
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar receitas',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
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
            'Adicione ingredientes primeiro',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoRecipesState(BuildContext context, List<Ingredient> ingredients) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma receita encontrada',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Tente adicionar mais ingredientes ou diferentes tipos',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Adicionar Mais Ingredientes'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesList(
    BuildContext context,
    List<Recipe> recipes,
    List<Ingredient> ingredients,
    List<String> favoriteRecipes,
    WidgetRef ref,
  ) {
    final ingredientNames = ingredients.map((ing) => ing.name).toList();
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${recipes.length} receita(s) encontrada(s)',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              final matchScore = recipe.calculateMatchScore(ingredientNames);
              final isFavorite = favoriteRecipes.contains(recipe.id);

              return RecipeCard(
                recipe: recipe,
                matchScore: matchScore,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/recipe-detail',
                    arguments: recipe,
                  );
                },
                isFavorite: isFavorite,
                onFavoriteToggle: () {
                  ref
                      .read(favoriteRecipesProvider.notifier)
                      .toggleFavorite(recipe.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
