import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';
import 'translation_service.dart';

class RecipeService {
  // Edamam API credentials
  static const String _edamamAppId = 'b9347332';
  static const String _edamamAppKey = '3db2d2ddf00d3f4de09d42cf0c5eb01c';
  static const String _edamamBaseUrl = 'https://api.edamam.com/api/recipes/v2';
  
  // TheMealDB API (100% free, no limits)
  static const String _mealDbBaseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Mock data for ultimate fallback
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

    print('🔍 Buscando receitas com ingredientes originais: $ingredients');

    // Traduzir ingredientes para inglês para as APIs
    final translatedIngredients = ingredients.map((ing) {
      return _translateIngredientToEnglish(ing);
    }).toList();

    print('🔍 Ingredientes traduzidos para APIs: $translatedIngredients');

    // Try Edamam API first (has better quality results with images)
    print('📡 Tentando Edamam API...');
    final edamamRecipes = await _tryEdamamAPI(translatedIngredients);
    print('✅ Edamam retornou ${edamamRecipes.length} receitas');
    if (edamamRecipes.isNotEmpty) {
      print('🎉 Usando receitas da Edamam');
      return edamamRecipes;
    }

    // Fallback to TheMealDB API (100% free, no limits)
    print('📡 Tentando TheMealDB API...');
    final mealDbRecipes = await _tryMealDbAPI(translatedIngredients);
    print('✅ TheMealDB retornou ${mealDbRecipes.length} receitas');
    if (mealDbRecipes.isNotEmpty) {
      print('🎉 Usando receitas do TheMealDB');
      return mealDbRecipes;
    }

    // Ultimate fallback to mock data (with original ingredients for matching)
    print('⚠️ Todas as APIs falharam, usando dados mock');
    return _getFilteredMockRecipes(ingredients);
  }

  String _translateIngredientToEnglish(String ingredient) {
    // Dicionário de tradução de português para inglês
    final Map<String, String> ptToEn = {
      'tomate': 'tomato',
      'cebola': 'onion',
      'alho': 'garlic',
      'ovos': 'eggs',
      'arroz': 'rice',
      'feijão': 'beans',
      'carne': 'beef',
      'frango': 'chicken',
      'peixe': 'fish',
      'queijo': 'cheese',
      'manteiga': 'butter',
      'azeite': 'olive oil',
      'limão': 'lemon',
      'sal': 'salt',
      'pimenta': 'pepper',
      'macarrão': 'pasta',
      'leite': 'milk',
      'farinha': 'flour',
      'batata': 'potato',
      'cenoura': 'carrot',
      'abóbora': 'pumpkin',
      'brócolis': 'broccoli',
      'milho': 'corn',
      'cogumelo': 'mushroom',
      'pão': 'bread',
      'abacaxi': 'pineapple',
      'morango': 'strawberry',
      'uva': 'grape',
      'maçã': 'apple',
      'banana': 'banana',
      'laranja': 'orange',
      'melancia': 'watermelon',
    };

    final lowerIngredient = ingredient.toLowerCase();
    if (ptToEn.containsKey(lowerIngredient)) {
      return ptToEn[lowerIngredient]!;
    }
    
    // Se não encontrar no dicionário, assume que já está em inglês
    return ingredient;
  }

  Future<List<Recipe>> _tryEdamamAPI(List<String> ingredients) async {
    try {
      final ingredientsString = ingredients.join(' ');
      final url = Uri.parse('$_edamamBaseUrl?type=public&q=$ingredientsString&app_id=$_edamamAppId&app_key=$_edamamAppKey');
      
      print('📡 URL Edamam: $url');

      final response = await http.get(url);

      print('📡 Status Edamam: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📦 Dados Edamam recebidos: ${data.keys}');
        if (data.containsKey('hits')) {
          print('📦 Quantidade de hits Edamam: ${data['hits'].length}');
        }
        return _parseEdamamResponse(data);
      } else {
        print('❌ Edamam API erro: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Edamam API exception: $e');
      return [];
    }
  }

  Future<List<Recipe>> _tryMealDbAPI(List<String> ingredients) async {
    try {
      // TheMealDB doesn't have ingredient search, so we search by first ingredient
      // and filter results
      final mainIngredient = ingredients.first;
      final url = Uri.parse('$_mealDbBaseUrl/filter.php?i=$mainIngredient');
      
      print('📡 URL MealDB: $url');

      final response = await http.get(url);

      print('📡 Status MealDB: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📦 Dados MealDB recebidos: ${data.keys}');
        if (data.containsKey('meals')) {
          print('📦 Quantidade de meals MealDB: ${data['meals']?.length}');
        }
        return _parseMealDbResponse(data, ingredients);
      } else {
        print('❌ TheMealDB API erro: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ TheMealDB API exception: $e');
      return [];
    }
  }

  List<Recipe> _parseMealDbResponse(Map<String, dynamic> data, List<String> availableIngredients) {
    print('🔄 Parseando resposta do MealDB...');
    final List<Recipe> recipes = [];
    
    if (data.containsKey('meals') && data['meals'] != null) {
      print('🔄 Quantidade de meals para processar: ${data['meals'].length}');
      for (var meal in data['meals']) {
        try {
          final recipe = _mapMealDbRecipe(meal);
          print('✅ Receita processada: ${recipe.title}');
          recipes.add(recipe);
        } catch (e) {
          print('❌ Erro ao processar receita do MealDB: $e');
        }
      }
    } else {
      print('⚠️ Resposta do MealDB não contém "meals"');
    }
    
    // Filter by ingredient matching (with translation)
    print('🔄 Filtrando ${recipes.length} receitas por matching de ingredientes...');
    final translatedIngredients = availableIngredients.map(_translateIngredientToEnglish).toList();
    final matchingRecipes = recipes.where((recipe) {
      final score = recipe.calculateMatchScore(translatedIngredients);
      return score > 0;
    }).toList();
    
    print('✅ Receitas após filtro de matching: ${matchingRecipes.length}');
    
    // Sort by match score
    matchingRecipes.sort((a, b) {
      final scoreA = a.calculateMatchScore(translatedIngredients);
      final scoreB = b.calculateMatchScore(translatedIngredients);
      return scoreB.compareTo(scoreA);
    });
    
    print('✅ Total de receitas do MealDB após matching: ${matchingRecipes.length}');
    return matchingRecipes;
  }

  Recipe _mapMealDbRecipe(Map<String, dynamic> data) {
    // Parse ingredients from TheMealDB format
    final ingredients = <String>[];
    for (int i = 1; i <= 20; i++) {
      final ingredient = data['strIngredient$i'];
      final measure = data['strMeasure$i'];
      if (ingredient != null && ingredient.toString().isNotEmpty) {
        final measureStr = measure != null ? ' ($measure)' : '';
        // Traduzir ingrediente para português
        final translatedIngredient = TranslationService.translateWithDictionary('$ingredient$measureStr');
        ingredients.add(translatedIngredient);
      }
    }

    // Build instructions from TheMealDB format
    final instructions = <String>[];
    for (int i = 1; i <= 20; i++) {
      final instruction = data['strInstructions$i']?.toString().trim() ?? data['strInstructions$i']?.toString().trim();
      if (instruction != null && instruction.isNotEmpty) {
        instructions.add(instruction);
      }
    }

    // Get image URL
    String? imageUrl = data['strMealThumb'] as String?;
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = null;
    }

    // Determine difficulty based on ingredients count
    String difficulty = TranslationService.translateWithDictionary('medium');
    if (ingredients.length < 5) {
      difficulty = TranslationService.translateWithDictionary('easy');
    } else if (ingredients.length > 10) {
      difficulty = TranslationService.translateWithDictionary('hard');
    }

    // Get category as cuisine
    String cuisine = TranslationService.translateWithDictionary(data['strCategory'] ?? 'Internacional');
    if (data['strArea'] != null) {
      cuisine = TranslationService.translateWithDictionary(data['strArea']);
    }

    return Recipe(
      id: data['idMeal']?.toString() ?? data['idMeal']?.toString() ?? DateTime.now().toString(),
      title: TranslationService.translateWithDictionary(data['strMeal'] ?? 'Receita sem nome'),
      description: TranslationService.translateWithDictionary(data['strCategory'] ?? 'Receita deliciosa'),
      ingredients: ingredients,
      instructions: instructions,
      prepTime: 30, // TheMealDB doesn't provide prep time
      difficulty: difficulty,
      imageUrl: imageUrl,
      cuisine: cuisine,
    );
  }

  List<Recipe> _parseEdamamResponse(Map<String, dynamic> data) {
    print('🔄 Parseando resposta da Edamam...');
    final List<Recipe> recipes = [];
    
    if (data.containsKey('hits') && data['hits'] != null) {
      print('🔄 Quantidade de hits para processar: ${data['hits'].length}');
      for (var hit in data['hits']) {
        try {
          final recipeData = hit['recipe'];
          final recipe = _mapEdamamRecipe(recipeData);
          print('✅ Receita processada: ${recipe.title}');
          recipes.add(recipe);
        } catch (e) {
          print('❌ Erro ao processar receita da Edamam: $e');
        }
      }
    } else {
      print('⚠️ Resposta da Edamam não contém "hits"');
    }
    
    print('✅ Total de receitas processadas da Edamam: ${recipes.length}');
    return recipes;
  }

  Recipe _mapEdamamRecipe(Map<String, dynamic> data) {
    final ingredients = <String>[];
    if (data['ingredientLines'] != null) {
      for (var ingredient in data['ingredientLines']) {
        // Traduzir ingredientes de volta para português
        final translatedIngredient = TranslationService.translateWithDictionary(ingredient.toString());
        ingredients.add(translatedIngredient);
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
    String difficulty = TranslationService.translateWithDictionary('medium');
    if (prepTime < 15) {
      difficulty = TranslationService.translateWithDictionary('easy');
    } else if (prepTime > 60) {
      difficulty = TranslationService.translateWithDictionary('hard');
    }

    // Get cuisine from tags or use default
    String cuisine = TranslationService.translateWithDictionary(data['cuisineType']?.toString() ?? 
                          data['mealType']?.toString() ?? 
                          'Internacional');

    return Recipe(
      id: data['uri'] ?? data['id']?.toString() ?? DateTime.now().toString(),
      title: TranslationService.translateWithDictionary(data['label'] ?? 'Receita sem nome'),
      description: TranslationService.translateWithDictionary(data['source'] ?? 'Receita deliciosa'),
      ingredients: ingredients,
      instructions: instructions,
      prepTime: prepTime,
      difficulty: difficulty,
      imageUrl: data['image'] as String?,
      cuisine: cuisine,
    );
  }

  List<Recipe> _getFilteredMockRecipes(List<String> ingredients) {
    print('🔄 Filtrando ${_mockRecipes.length} receitas mock por matching...');
    final matchingRecipes = _mockRecipes.where((recipe) {
      final score = recipe.calculateMatchScore(ingredients);
      return score > 0;
    }).toList();

    print('✅ Receitas mock após filtro: ${matchingRecipes.length}');

    // Sort by match score (highest first)
    matchingRecipes.sort((a, b) {
      final scoreA = a.calculateMatchScore(ingredients);
      final scoreB = b.calculateMatchScore(ingredients);
      return scoreB.compareTo(scoreA);
    });

    print('✅ Total de receitas mock retornadas: ${matchingRecipes.length}');
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
    print('🔍 Buscando receitas com query: $query');
    
    // Try Edamam API first
    print('📡 Tentando Edamam API para busca...');
    try {
      final url = Uri.parse('$_edamamBaseUrl?type=public&q=$query&app_id=$_edamamAppId&app_key=$_edamamAppKey');
      
      print('📡 URL Edamam search: $url');

      final response = await http.get(url);

      print('📡 Status Edamam search: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📦 Dados Edamam search recebidos');
        if (data.containsKey('hits')) {
          print('📦 Quantidade de hits Edamam search: ${data['hits'].length}');
        }
        return _parseEdamamResponse(data);
      } else {
        print('❌ Edamam API search erro: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Edamam API search exception: $e');
    }

    // Fallback to TheMealDB API
    print('📡 Tentando TheMealDB API para busca...');
    try {
      final url = Uri.parse('$_mealDbBaseUrl/search.php?s=$query');
      
      print('📡 URL MealDB search: $url');

      final response = await http.get(url);

      print('📡 Status MealDB search: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📦 Dados MealDB search recebidos');
        if (data['meals'] != null) {
          print('📦 Quantidade de meals MealDB search: ${data['meals'].length}');
          return data['meals'].map<Recipe>((meal) => _mapMealDbRecipe(meal)).toList();
        }
      } else {
        print('❌ TheMealDB API search erro: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ TheMealDB API search exception: $e');
    }

    // Ultimate fallback to mock search
    print('⚠️ Todas as APIs de busca falharam, usando mock search');
    return _searchMockRecipes(query);
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
