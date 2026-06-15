import '../models/ingredient.dart';

class IngredientService {
  static final Map<String, Ingredient> _ingredients = {
    'tomate': Ingredient(
      id: 'tomate',
      name: 'Tomate',
      category: 'Vegetais',
      emoji: '🍅',
    ),
    'cebola': Ingredient(
      id: 'cebola',
      name: 'Cebola',
      category: 'Vegetais',
      emoji: '🧅',
    ),
    'alho': Ingredient(
      id: 'alho',
      name: 'Alho',
      category: 'Vegetais',
      emoji: '🧄',
    ),
    'ovos': Ingredient(
      id: 'ovos',
      name: 'Ovos',
      category: 'Proteínas',
      emoji: '🥚',
    ),
    'arroz': Ingredient(
      id: 'arroz',
      name: 'Arroz',
      category: 'Grãos',
      emoji: '🍚',
    ),
    'feijão': Ingredient(
      id: 'feijão',
      name: 'Feijão',
      category: 'Grãos',
      emoji: '🫘',
    ),
    'carne': Ingredient(
      id: 'carne',
      name: 'Carne',
      category: 'Proteínas',
      emoji: '🥩',
    ),
    'frango': Ingredient(
      id: 'frango',
      name: 'Frango',
      category: 'Proteínas',
      emoji: '🍗',
    ),
    'peixe': Ingredient(
      id: 'peixe',
      name: 'Peixe',
      category: 'Proteínas',
      emoji: '🐟',
    ),
    'queijo': Ingredient(
      id: 'queijo',
      name: 'Queijo',
      category: 'Laticínios',
      emoji: '🧀',
    ),
    'manteiga': Ingredient(
      id: 'manteiga',
      name: 'Manteiga',
      category: 'Laticínios',
      emoji: '🧈',
    ),
    'azeite': Ingredient(
      id: 'azeite',
      name: 'Azeite',
      category: 'Óleos',
      emoji: '🫒',
    ),
    'limão': Ingredient(
      id: 'limão',
      name: 'Limão',
      category: 'Frutas',
      emoji: '🍋',
    ),
    'sal': Ingredient(
      id: 'sal',
      name: 'Sal',
      category: 'Temperos',
      emoji: '🧂',
    ),
    'pimenta': Ingredient(
      id: 'pimenta',
      name: 'Pimenta',
      category: 'Temperos',
      emoji: '🌶️',
    ),
    'macarrão': Ingredient(
      id: 'macarrão',
      name: 'Macarrão',
      category: 'Grãos',
      emoji: '🍝',
    ),
    'leite': Ingredient(
      id: 'leite',
      name: 'Leite',
      category: 'Laticínios',
      emoji: '🥛',
    ),
    'farinha': Ingredient(
      id: 'farinha',
      name: 'Farinha',
      category: 'Grãos',
      emoji: '🌾',
    ),
    'batata': Ingredient(
      id: 'batata',
      name: 'Batata',
      category: 'Vegetais',
      emoji: '🥔',
    ),
    'cenoura': Ingredient(
      id: 'cenoura',
      name: 'Cenoura',
      category: 'Vegetais',
      emoji: '🥕',
    ),
    'abóbora': Ingredient(
      id: 'abóbora',
      name: 'Abóbora',
      category: 'Vegetais',
      emoji: '🎃',
    ),
    'brócolis': Ingredient(
      id: 'brócolis',
      name: 'Brócolis',
      category: 'Vegetais',
      emoji: '🥦',
    ),
    'milho': Ingredient(
      id: 'milho',
      name: 'Milho',
      category: 'Vegetais',
      emoji: '🌽',
    ),
    'cogumelo': Ingredient(
      id: 'cogumelo',
      name: 'Cogumelo',
      category: 'Vegetais',
      emoji: '🍄',
    ),
    'pão': Ingredient(
      id: 'pão',
      name: 'Pão',
      category: 'Grãos',
      emoji: '🍞',
    ),
    'abacaxi': Ingredient(
      id: 'abacaxi',
      name: 'Abacaxi',
      category: 'Frutas',
      emoji: '🍍',
    ),
    'morango': Ingredient(
      id: 'morango',
      name: 'Morango',
      category: 'Frutas',
      emoji: '🍓',
    ),
    'uva': Ingredient(
      id: 'uva',
      name: 'Uva',
      category: 'Frutas',
      emoji: '🍇',
    ),
    'maçã': Ingredient(
      id: 'maçã',
      name: 'Maçã',
      category: 'Frutas',
      emoji: '🍎',
    ),
    'banana': Ingredient(
      id: 'banana',
      name: 'Banana',
      category: 'Frutas',
      emoji: '🍌',
    ),
    'laranja': Ingredient(
      id: 'laranja',
      name: 'Laranja',
      category: 'Frutas',
      emoji: '🍊',
    ),
    'melancia': Ingredient(
      id: 'melancia',
      name: 'Melancia',
      category: 'Frutas',
      emoji: '🍉',
    ),
  };

  static List<Ingredient> getAllIngredients() {
    return _ingredients.values.toList();
  }

  static Ingredient? getIngredient(String id) {
    return _ingredients[id.toLowerCase()];
  }

  static List<Ingredient> searchIngredients(String query) {
    final lowerQuery = query.toLowerCase();
    return _ingredients.values
        .where((ing) =>
            ing.name.toLowerCase().contains(lowerQuery) ||
            ing.id.toLowerCase().contains(lowerQuery))
        .toList();
  }

  static Ingredient createCustomIngredient(String name) {
    return Ingredient(
      id: name.toLowerCase().replaceAll(' ', '_'),
      name: name,
      category: 'Outros',
      emoji: null,
    );
  }
}
