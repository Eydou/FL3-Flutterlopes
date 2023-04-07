import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_lopes/model/recipe.dart';

class RecipeRepo {

  static Future<List<Recipe>> getAll() async
  {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Recipe> result = [];

    return result;
  }
}