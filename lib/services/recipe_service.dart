import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  // Edamam API credentials
  static const String _appId = 'b9347332';
  static const String _appKey = '3db2d2ddf00d3f4de09d42cf0c5eb01c';
  static const String _baseUrl = 'https://api.edamam.com/api/recipes/v2';

  // Mock data for fallback
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
    // Return mock data for now
    return _mockRecipes;
  }

  Future<List<Recipe>> getRecipesByIngredients(List<String> ingredients) async {
    if (ingredients.isEmpty) {
      return [];
    }

    try {
      // Build ingredients string for API
      final ingredientsString = ingredients.join(',');
      final url = Uri.parse('$_baseUrl/by-ingredients?ingredients=$ingredientsString&app_id=$_appId&app_key=$_appKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseEdamamResponse(data);
      } else {
        print('Erro na API: ${response.statusCode}');
        // Fallback to mock data with filtering
        return _getFilteredMockRecipes(ingredients);
      }
    } catch (e) {
      print('Erro ao buscar receitas: $e');
      // Fallback to mock data with filtering
      return _getFilteredMockRecipes(ingredients);
    }
  }

  List<Recipe> _parseEdamamResponse(Map<String, dynamic> data) {
    final List<Recipe> recipes = [];
    
    if (data.containsKey('hits') && data['hits'] != null) {
      for (var hit in data['hits']) {
        try {
          final recipeData = hit['recipe'];
          recipes.add(_mapEdamamRecipe(recipeData));
        } catch (e) {
          print('Erro ao processar receita: $e');
        }
      }
    }
    
    return recipes;
  }

  Recipe _mapEdamamRecipe(Map<String, dynamic> data) {
    final ingredients = <String>[];
    if (data['ingredientLines'] != null) {
      for (var ingredient in data['ingredientLines']) {
        ingredients.add(ingredient.toString());
      }
    }

    final instructions = <String>[];
    if (data['instructionLines'] != null) {
      for (var instruction in data['instructionLines']) {
        instructions.add(instruction.toString());
      }
    } else if (data['url'] != null) {
      instructions.add('Para instruções detalhadas, visite: ${data['url']}');
    } else {
      instructions.add('Instruções não disponíveis');
    }

    // Determine difficulty based on time and ingredients
    final prepTime = (data['totalTime'] as num?)?.toInt() ?? 30;
    String difficulty = 'Média';
    if (prepTime < 15) {
      difficulty = 'Fácil';
    } else if (prepTime > 60) {
      difficulty = 'Difícil';
    }

    // Get cuisine from tags or use default
    String cuisine = 'Internacional';
    if (data['cuisineType'] != null && data['cuisineType'].isNotEmpty) {
      cuisine = data['cuisineType'][0].toString();
    } else if (data['mealType'] != null && data['mealType'].isNotEmpty) {
      cuisine = data['mealType'][0].toString();
    }

    return Recipe(
      id: data['uri'] ?? data['id']?.toString() ?? DateTime.now().toString(),
      title: data['label'] ?? 'Receita sem nome',
      description: data['source'] ?? 'Receita deliciosa',
      ingredients: ingredients,
      instructions: instructions,
      prepTime: prepTime,
      difficulty: difficulty,
      imageUrl: data['image'] as String?,
      cuisine: cuisine,
    );
  }

  List<Recipe> _getFilteredMockRecipes(List<String> ingredients) {
    final matchingRecipes = _mockRecipes.where((recipe) {
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
    // For now, search in mock recipes
    try {
      return _mockRecipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final url = Uri.parse('$_baseUrl?type=public&q=$query&app_id=$_appId&app_key=$_appKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseEdamamResponse(data);
      } else {
        print('Erro na API: ${response.statusCode}');
        return _searchMockRecipes(query);
      }
    } catch (e) {
      print('Erro ao buscar receitas: $e');
      return _searchMockRecipes(query);
    }
  }

  List<Recipe> _searchMockRecipes(String query) {
    final lowerQuery = query.toLowerCase();
    
    return _mockRecipes.where((recipe) {
      return recipe.title.toLowerCase().contains(lowerQuery) ||
          recipe.description.toLowerCase().contains(lowerQuery) ||
          recipe.cuisine.toLowerCase().contains(lowerQuery) ||
          recipe.ingredients.any((ing) => ing.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
