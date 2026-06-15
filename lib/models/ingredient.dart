class Ingredient {
  final String id;
  final String name;
  final String category;
  final String? emoji;

  Ingredient({
    required this.id,
    required this.name,
    required this.category,
    this.emoji,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      emoji: json['emoji'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      if (emoji != null) 'emoji': emoji,
    };
  }

  Ingredient copyWith({
    String? id,
    String? name,
    String? category,
    String? emoji,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
    );
  }
}
