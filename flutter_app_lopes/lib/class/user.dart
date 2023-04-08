import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String email;
  final String picture;
  final String uid;
  final String username;
  final String role;

  User({
    required this.email,
    required this.picture,
    required this.uid,
    required this.username,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      picture: json['picture'],
      uid: json['uid'],
      username: json['username'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'picture': picture,
      'uid': uid,
      'username': username,
      'role': role,
    };
  }
}

class UserStream {
  StreamController<User?> _streamController = StreamController<User?>();

  UserStream() {
    final user = FirebaseAuth.instance.currentUser;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    userRef.snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        _streamController.add(User.fromJson(docSnapshot.data()!));
      }
    });
  }

  Stream<User?> get stream => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}
