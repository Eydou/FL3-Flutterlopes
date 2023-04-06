import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/recipe.dart';


List<Widget> recipeSearchfromList(List<QueryDocumentSnapshot<Recipe>> ?recipes, String search) {
  final List<Widget> list = [];

  recipes?.forEach((element) {
    final Recipe recipe = element.data();
    if (recipe.name.contains(search)) {
      list.add(RecipeSearchItemWidget(onClicked: () async {}, image: 'https://images.squarespace-cdn.com/content/v1/57879a6cbebafb879f256735/1579721909133-R2KSZ8VGDGBI90DYATBK/header4.jpg', name: recipe.name, author: recipe.name, note: 5, recipe: recipe,));
    }
  });

  return list;
}

class RecipeSearchItemWidget extends StatelessWidget {
  final VoidCallback onClicked;
  final String image;
  final String name;
  final String author;
  final double note;
  final bool isFav = false;
  final Recipe recipe;

  const RecipeSearchItemWidget({
    Key? key,
    required this.onClicked,
    required this.image,
    required this.name,
    required this.author,
    required this.note,
    required this.recipe,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Image(context),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "By " + author,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: IconButton(
              color: Colors.redAccent,
              icon: const Icon(Icons.favorite),
              onPressed: () {

              },
            ),
          ),
        ),
      ],
    );
  }

  Widget Image(BuildContext context) {
    final myImage = NetworkImage(image);
    return ClipRect(

        child: Padding(
          padding: EdgeInsets.all(5),
          child: Material(
            color: Colors.transparent,
            child: Ink.image(
              image: myImage,
              width: 128,
              height: 128,
              fit: BoxFit.cover,
              child: InkWell(onTap: () {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeDetails(recipe: recipe)),
                );*/
              }),
            ),
          ),
        )
    );
  }
}