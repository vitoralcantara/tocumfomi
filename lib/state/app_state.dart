import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/recipe_service.dart';
import '../services/ingredient_service.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';

// Service provider
final recipeServiceProvider = Provider<RecipeService>((ref) {
  return RecipeService();
});

final ingredientServiceProvider = Provider<IngredientService>((ref) {
  return IngredientService();
});

// Available ingredients provider
class AvailableIngredientsNotifier extends StateNotifier<List<Ingredient>> {
  AvailableIngredientsNotifier() : super([]) {
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    final prefs = await SharedPreferences.getInstance();
    final ingredientIds = prefs.getStringList('available_ingredients') ?? [];
    
    final ingredients = ingredientIds
        .map((id) => IngredientService.getIngredient(id))
        .whereType<Ingredient>()
        .toList();
    
    state = ingredients;
  }

  Future<void> addIngredient(Ingredient ingredient) async {
    if (!state.any((ing) => ing.id == ingredient.id)) {
      final newState = [...state, ingredient];
      state = newState;
      await _saveIngredients();
    }
  }

  Future<void> removeIngredient(String ingredientId) async {
    final newState = state.where((ing) => ing.id != ingredientId).toList();
    state = newState;
    await _saveIngredients();
  }

  Future<void> clearIngredients() async {
    state = [];
    await _saveIngredients();
  }

  Future<void> _saveIngredients() async {
    final prefs = await SharedPreferences.getInstance();
    final ingredientIds = state.map((ing) => ing.id).toList();
    await prefs.setStringList('available_ingredients', ingredientIds);
  }
}

final availableIngredientsProvider =
    StateNotifierProvider<AvailableIngredientsNotifier, List<Ingredient>>((ref) {
  return AvailableIngredientsNotifier();
});

// Recipes provider based on available ingredients
final recipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final ingredients = ref.watch(availableIngredientsProvider);
  final recipeService = ref.watch(recipeServiceProvider);
  
  if (ingredients.isEmpty) {
    return [];
  }
  
  final ingredientNames = ingredients.map((ing) => ing.name).toList();
  return recipeService.getRecipesByIngredients(ingredientNames);
});

// Favorite recipes provider
class FavoriteRecipesNotifier extends StateNotifier<List<String>> {
  FavoriteRecipesNotifier() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_recipes') ?? [];
    state = favorites;
  }

  Future<void> toggleFavorite(String recipeId) async {
    if (state.contains(recipeId)) {
      final newState = state.where((id) => id != recipeId).toList();
      state = newState;
    } else {
      final newState = [...state, recipeId];
      state = newState;
    }
    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_recipes', state);
  }

  bool isFavorite(String recipeId) {
    return state.contains(recipeId);
  }
}

final favoriteRecipesProvider =
    StateNotifierProvider<FavoriteRecipesNotifier, List<String>>((ref) {
  return FavoriteRecipesNotifier();
});
