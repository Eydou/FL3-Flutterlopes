class User {
  final String email;
  final String picture;
  final String uid;
  final String username;

  User({
    required this.email,
    required this.picture,
    required this.uid,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      picture: json['picture'],
      uid: json['uid'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'picture': picture,
      'uid': uid,
      'username': username,
    };
  }
}
