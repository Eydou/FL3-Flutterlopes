import 'dart:convert';

List<Recipe> recipeFromJson(String str) => List<Recipe>.from(json.decode(str).map((x) => Recipe.fromJson(x)));

String recipeToJson(List<Recipe> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Recipe {
  final String name;
  final int people;
  final int time;
  String? id = "";
  String? userId = "";
  final List<Ingredient> ingredients;
  final List<String> steps;
  final String image;

  Recipe({
    required this.name,
    required this.people,
    required this.time,
    this.id,
    this.userId,
    required this.ingredients,
    required this.steps,
    required this.image
  });


  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    name: json["name"],
    people: json["people"],
    time: json["time"],
    id: json["id"],
    userId: json["userId"],
    ingredients: List<Ingredient>.from(json["ingredients"].map((x) => Ingredient.fromJson(x))),
    steps: List<String>.from(json["steps"].map((x) => x)),
    image: json["image"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "people": people,
    "time": time,
    "id": id,
    "userId": userId,
    "ingredients": List<dynamic>.from(ingredients.map((x) => x.toJson())),
    "steps": List<dynamic>.from(steps.map((x) => x)),
    "image": image
  };
}

class Ingredient {
  Ingredient({
    required this.name,
    required this.quantity,
    this.type,
  });

  final String name;
  final int quantity;
  String? type;

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    name: json["name"],
    quantity: json["quantity"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "quantity": quantity,
    "type": type,
  };
}
