import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../class/recipe.dart';
import 'package:flutter_app_lopes/class/user.dart' as AppUser;

import '../class/user.dart';
import '../widgets/recipeAuthorWidgets.dart';
import '../widgets/recipeDetailsWidget.dart';
import '../widgets/recipeIngredientWidget.dart';
import '../widgets/recipeStepsWidget.dart';
import './recipeSteps.dart';

class RecipeDetails extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetails({Key? key, required this.recipe}) : super(key: key);
  Stream<User> readRecipes() => FirebaseFirestore.instance.collection("users/${recipe.userId!}").snapshots().map((snapshot) => snapshot.docs.map((e) => User.fromJson(e.data())).toList()[0]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(recipe.name, style: const TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold)),
      ),
      body: Container(
          child: ListView(
              children: <Widget>[
                Container(
                  child: Padding(padding:
                  const EdgeInsets.fromLTRB(45, 0, 35, 10),
                      child: Image.network(recipe.image, width: 300, height: MediaQuery.of(context).size.width < 500 ? 150 : 300, fit: BoxFit.cover)
                  ),
                ),
                StreamBuilder<AppUser.User?>(
                    stream: AppUser.UserStream().stream,
                    builder: (context, snapshot) {
                      return Container(
                        child: Padding(padding:
                        const EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: RecipeAuthor(image: snapshot.data!.picture, name: snapshot.data!.username, note: 5)
                        ),
                      );
                    }),
                const Padding(padding:
                EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: RecipeDetailsHeader(isServe: true, value: 2, unit: "p",),
                ),
                Container(
                  child: RecipeDetailsHeader(isServe: false, value: recipe.time, unit: "mn",),
                ),
                const Padding(padding: EdgeInsets.only(left: 15), child: Text(
                  "Ingredients",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontFamily: 'CircularStd',
                      fontWeight: FontWeight.bold),
                )),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: getListIngredientsWidgetFromMap(recipe.ingredients),
                ),
                const Padding(padding: EdgeInsets.only(left: 15), child: Text(
                  "Steps",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontFamily: 'CircularStd',
                      fontWeight: FontWeight.bold),
                )),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: getListStepsWidgetFromMap(recipe.steps),
                ),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecipeStepsPage(recipe: recipe)),
                      );
                    },
                    child:
                    const Text(
                        "Read step by step"
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                        textStyle:
                        MaterialStateProperty.all(const TextStyle(fontSize: 12))),
                  ),
                ),
              ]
          )
      ),
    );
  }
}