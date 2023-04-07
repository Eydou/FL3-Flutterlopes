import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lopes/pages/createRecipe.dart';
import 'package:flutter_app_lopes/pages/recipe.dart';

import '../class/recipe.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firebaseAuth = FirebaseAuth.instance;

  Widget buildRowItemsGrid(BuildContext context, Recipe recipe, int index) {
    return Container(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe)),
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
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                      child:  Padding(padding: EdgeInsets.all(10),
                      child: SizedBox(
                          height: 30,
                          width: 50, child:TextButton(
                          child:FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                            'Delete',
                              style: TextStyle(fontSize: 11),
                          )),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.redAccent,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                          ),
                          onPressed: () {
                            setState(() {
                              FirebaseFirestore.instance.collection('recipes')
                                  .doc(recipe.id) // <-- Doc ID to be deleted.
                                  .delete() // <-- Delete
                                  .then((_) => print('Deleted'))
                                  .catchError((error) => print('Delete failed: $error'));
                            });
                          },
                        )
                    )))
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Stream<List<Recipe>> readRecipes() => FirebaseFirestore.instance.collection("recipes").snapshots().map((snapshot) => snapshot.docs.map((e) => Recipe.fromJson(e.data())).toList());

    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.black87),),
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: StreamBuilder<List<Recipe>>(stream: readRecipes(), builder: (context, snapshot) {
        if (snapshot.hasData) {
          final recipe = snapshot.data!;
          final filteredRecipes = recipe.where((element) => element.userId == _firebaseAuth.currentUser!.uid).toList();
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                child: ProfilePicture(_firebaseAuth.currentUser!.email),
              ),
             // InformationProfile(context),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 3/4,
                    scrollDirection: Axis.vertical,
                    physics: PageScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(snapshot.data!.length, (index) {
                      return buildRowItemsGrid(context, filteredRecipes[index], index);
                    })),
              ),
              SizedBox(
                  height: 40,
                  width: 250,
                  child: TextButton(
                    child: Text(
                      'Create recipe',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.redAccent,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateRecipe()),
                      );
                    },
                  )),
              SizedBox(height: 20,),
            ],
          );
        } if(snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        else {
          return Center(child: CircularProgressIndicator());
        }
      })
    );
  }

  Widget buildRecipe(Recipe recipe) =>  ListTile(
    title: Text(recipe.name)
  );
}

Row ProfilePicture(String? name) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(1), // Border radius
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {},
            child: ClipOval(
                child: Image.network(
                    'https://media.licdn.com/dms/image/C5603AQFxIX8VwOWAIQ/profile-displayphoto-shrink_800_800/0/1554474920022?e=2147483647&v=beta&t=ONX58uRfw7aX4VuTgPda2pn2Y8YKa0tPTIY_3aN1Yrg')),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
        child: Text(
          name!.split("@").first.toCapitalized(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      )
    ],
  );
}

Padding InformationProfile(BuildContext context) {
  return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Color(0x33000000),
                  offset: Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ]));
}
