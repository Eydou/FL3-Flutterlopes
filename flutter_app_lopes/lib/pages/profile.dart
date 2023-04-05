import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lopes/pages/createRecipe.dart';

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
  @override
  Widget build(BuildContext context) {
    Stream<List<Recipe>> readRecipes() => FirebaseFirestore.instance.collection("recipes").snapshots().map((snapshot) => snapshot.docs.map((e) => Recipe.fromJson(e.data())).toList());
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: StreamBuilder<List<Recipe>>(stream: readRecipes(), builder: (context, snapshot) {
        if (snapshot.hasData) {
          final recipe = snapshot.data!;
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                child: ProfilePicture(_firebaseAuth.currentUser!.email),
              ),
              InformationProfile(context),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 40, 20, 40),
                child: Container(
                  color: Colors.redAccent,
                  height: 350,
                  child: ListView(
                    children: recipe.map(buildRecipe).toList(),
                  ),
                ),
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
                  ))
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
