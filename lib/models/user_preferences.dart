class UserPreferences {
  final List<String> favoriteIngredients;
  final List<String> favoriteRecipes;
  final List<String> dietaryRestrictions;

  UserPreferences({
    required this.favoriteIngredients,
    required this.favoriteRecipes,
    required this.dietaryRestrictions,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      favoriteIngredients: List<String>.from(json['favoriteIngredients'] as List),
      favoriteRecipes: List<String>.from(json['favoriteRecipes'] as List),
      dietaryRestrictions:
          List<String>.from(json['dietaryRestrictions'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favoriteIngredients': favoriteIngredients,
      'favoriteRecipes': favoriteRecipes,
      'dietaryRestrictions': dietaryRestrictions,
    };
  }

  UserPreferences copyWith({
    List<String>? favoriteIngredients,
    List<String>? favoriteRecipes,
    List<String>? dietaryRestrictions,
  }) {
    return UserPreferences(
      favoriteIngredients: favoriteIngredients ?? this.favoriteIngredients,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
      dietaryRestrictions:
          dietaryRestrictions ?? this.dietaryRestrictions,
    );
  }
}
