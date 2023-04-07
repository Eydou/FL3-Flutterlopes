class Recipe {
  final String id;
  final String userId;
  final String name;
  final List<Map<String, dynamic>> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.userId,
    required this.name,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json)
  {
    final List<String> steps = json['steps'] is Iterable ? List.from(json['steps']) : [];
    final List<Map<String, dynamic>> ingredients = json['ingredients'] is Iterable ? List.from(json['ingredients']) : [];

    return Recipe(
      id: json?['id'],
      userId: json?['userId'],
      name: json?['name'],
      ingredients: ingredients,
      steps: steps,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'ingredients': ingredients,
    'steps': steps,
  };
}