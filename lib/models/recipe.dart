class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTime;
  final String difficulty;
  final String? imageUrl;
  final String cuisine;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.difficulty,
    this.imageUrl,
    required this.cuisine,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      ingredients: List<String>.from(json['ingredients'] as List),
      instructions: List<String>.from(json['instructions'] as List),
      prepTime: json['prepTime'] as int,
      difficulty: json['difficulty'] as String,
      imageUrl: json['imageUrl'] as String?,
      cuisine: json['cuisine'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'prepTime': prepTime,
      'difficulty': difficulty,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'cuisine': cuisine,
    };
  }

  int calculateMatchScore(List<String> availableIngredients) {
    final matchingIngredients = ingredients.where(
      (ingredient) => availableIngredients.any(
        (available) => ingredient.toLowerCase().contains(available.toLowerCase()),
      ),
    );
    return matchingIngredients.length;
  }
}
