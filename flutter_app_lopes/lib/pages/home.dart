import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lopes/pages/profile.dart';
import 'package:flutter_app_lopes/pages/recipe.dart';
import 'package:flutter_app_lopes/pages/recipeDetails.dart';

import '../class/recipe.dart';
import '../widgets/navigation_drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController editingController = TextEditingController();

  Stream<List<Recipe>> readRecipes() => FirebaseFirestore.instance
      .collection("recipes")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((e) => Recipe.fromJson(e.data())).toList());

  Widget buildRowItemsGrid(BuildContext context, Recipe recipe) {
    return Container(
        child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecipeDetails(recipe: recipe)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5.0,
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Image.network(
                "${recipe.image}",
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover),
            ),
            Column(
              children: [
                Container(
                  child: Text(recipe.name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text("P: ${recipe.people.toString()}",
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text("${recipe.time.toString()} min",
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.0, top: 10),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipRRect(
                  child: CircleAvatar(
                radius: 56,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(1), // Border radius
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child: ClipOval(
                        child: Image.network(
                            'https://media.licdn.com/dms/image/C5603AQFxIX8VwOWAIQ/profile-displayphoto-shrink_800_800/0/1554474920022?e=2147483647&v=beta&t=ONX58uRfw7aX4VuTgPda2pn2Y8YKa0tPTIY_3aN1Yrg'
                        ),
                    ),
                  ),
                ),
              )),
            ),
          )
        ],
      ),
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      drawer: const NavigationDrawerLopes(),
      body: StreamBuilder<List<Recipe>>(
          stream: readRecipes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final recipe = snapshot.data!;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: editingController,
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                Text(
                  "",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Trending",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 3/4,
                      scrollDirection: Axis.vertical,
                      physics: PageScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(snapshot.data!.length, (index) {
                        return buildRowItemsGrid(context, recipe[index]);
                      })),
                )
              ]);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }));
}
