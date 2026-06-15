import '../models/recipe.dart';

class RecipeService {
  // Mock data for demonstration
  final List<Recipe> _mockRecipes = [
    Recipe(
      id: '1',
      title: 'Omelete de Queijo',
      description: 'Uma omelete simples e deliciosa com queijo derretido',
      ingredients: ['ovos', 'queijo', 'manteiga', 'sal'],
      instructions: [
        'Bata os ovos em uma tigela',
        'Aqueça a manteiga em uma frigideira',
        'Despeje os ovos e cozinhe em fogo médio',
        'Adicione o queijo quando estiver quase pronto',
        'Dobre a omelete e sirva'
      ],
      prepTime: 10,
      difficulty: 'Fácil',
      imageUrl: null,
      cuisine: 'Brasileira',
    ),
    Recipe(
      id: '2',
      title: 'Pasta com Molho de Tomate',
      description: 'Espaguete com molho de tomate caseiro',
      ingredients: ['macarrão', 'tomate', 'cebola', 'alho', 'azeite', 'manjericão'],
      instructions: [
        'Cozinhe o macarrão conforme instruções',
        'Pique cebola e alho',
        'Refogue no azeite',
        'Adicione tomates picados',
        'Cozinhe por 15 minutos',
        'Misture com o macarrão e adicione manjericão'
      ],
      prepTime: 25,
      difficulty: 'Fácil',
      imageUrl: null,
      cuisine: 'Italiana',
    ),
    Recipe(
      id: '3',
      title: 'Arroz com Feijão',
      description: 'O clássico arroz com feijão brasileiro',
      ingredients: ['arroz', 'feijão', 'cebola', 'alho', 'óleo'],
      instructions: [
        'Cozinhe o feijão na pressão',
        'Refogue cebola e alho no óleo',
        'Adicione o arroz e frite',
        'Adicione água e cozinhe',
        'Sirva com o feijão'
      ],
      prepTime: 40,
      difficulty: 'Fácil',
      imageUrl: null,
      cuisine: 'Brasileira',
    ),
    Recipe(
      id: '4',
      title: 'Salada Caesar',
      description: 'Salada clássica com croutons e parmesão',
      ingredients: ['alface', 'croutons', 'queijo parmesão', 'molho caesar'],
      instructions: [
        'Lave e corte a alface',
        'Adicione croutons',
        'Rale queijo parmesão por cima',
        'Regue com molho caesar',
        'Misture bem e sirva'
      ],
      prepTime: 10,
      difficulty: 'Fácil',
      imageUrl: null,
      cuisine: 'Internacional',
    ),
    Recipe(
      id: '5',
      title: 'Frango Grelhado',
      description: 'Peito de frango grelhado com ervas',
      ingredients: ['frango', 'limão', 'alho', 'orégano', 'azeite', 'sal'],
      instructions: [
        'Tempere o frango com limão, alho e orégano',
        'Aqueça a frigideira com azeite',
        'Grelhe o frango de ambos os lados',
        'Tempere com sal a gosto',
        'Sirva com acompanhamentos'
      ],
      prepTime: 20,
      difficulty: 'Média',
      imageUrl: null,
      cuisine: 'Brasileira',
    ),
    Recipe(
      id: '6',
      title: 'Panqueca de Carne',
      description: 'Panquecas recheadas com carne moída',
      ingredients: ['farinha', 'leite', 'ovos', 'carne moída', 'molho de tomate'],
      instructions: [
        'Prepare a massa das panquecas',
        'Cozinhe as panquecas',
        'Refogue a carne moída com temperos',
        'Recheie as panquecas',
        'Cubra com molho de tomate e aqueça'
      ],
      prepTime: 45,
      difficulty: 'Média',
      imageUrl: null,
      cuisine: 'Brasileira',
    ),
  ];

  Future<List<Recipe>> getRecipes() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockRecipes;
  }

  Future<List<Recipe>> getRecipesByIngredients(List<String> ingredients) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final allRecipes = await getRecipes();
    
    // Filter recipes that match available ingredients
    final matchingRecipes = allRecipes.where((recipe) {
      final score = recipe.calculateMatchScore(ingredients);
      return score > 0;
    }).toList();

    // Sort by match score (highest first)
    matchingRecipes.sort((a, b) {
      final scoreA = a.calculateMatchScore(ingredients);
      final scoreB = b.calculateMatchScore(ingredients);
      return scoreB.compareTo(scoreA);
    });

    return matchingRecipes;
  }

  Future<Recipe?> getRecipeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _mockRecipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final allRecipes = await getRecipes();
    final lowerQuery = query.toLowerCase();
    
    return allRecipes.where((recipe) {
      return recipe.title.toLowerCase().contains(lowerQuery) ||
          recipe.description.toLowerCase().contains(lowerQuery) ||
          recipe.cuisine.toLowerCase().contains(lowerQuery) ||
          recipe.ingredients.any((ing) => ing.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
