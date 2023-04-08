import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  final String name;
  final String picture;

  User({
    required this.name,
    required this.picture
  });


  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    picture: json["picture"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "picture": picture
  };
}

