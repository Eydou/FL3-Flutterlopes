import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lopes/pages/profile.dart';
import 'package:flutter_app_lopes/pages/recipe.dart';
import 'package:flutter_app_lopes/pages/recipeDetails.dart';

import '../class/recipe.dart';
import '../fonction/uploadImage.dart';
import '../widgets/navigation_drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController editingController = TextEditingController();
  String? _imageUrl;

  Stream<List<Recipe>> readRecipes() => FirebaseFirestore.instance
      .collection("recipes")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((e) => Recipe.fromJson(e.data())).toList());

  @override
  void initState() {
    getProfilePictureUrl();
    super.initState();
  }

  Future<String?> getProfilePictureUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    final ref = FirebaseStorage.instance.ref(
        'users/${user.uid}/profilePictures/profile_picture_${user.uid}.jpg');

    try {
      final downloadUrl = await ref.getDownloadURL();
      _imageUrl = downloadUrl;
      setState(() {});
      return downloadUrl;
    } catch (e) {
      print('Error retrieving profile picture: $e');
      return null;
    }
  }

  Widget buildRowItemsGrid(BuildContext context, Recipe recipe) {
    return Container(
        child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RecipeDetails(recipe: recipe)),
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
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Image.network("${recipe.image}",
                  height: 100, width: double.infinity, fit: BoxFit.cover),
            ),
            Column(
              children: [
                Container(
                  child: Text(recipe.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
                ),
                SizedBox(
                  height: 30,
                ),
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
  Widget build(BuildContext context) {
    Stream<List<Recipe>> readRecipes() => FirebaseFirestore.instance.collection("recipes").snapshots().map((snapshot) => snapshot.docs.map((e) => Recipe.fromJson(e.data())).toList());

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black87),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15.0, top: 10),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: StreamBuilder<String?>(
                  stream: ProfilePictureStream().stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data!),
                          radius: 80.0,
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        ),
                        child: CircularProgressIndicator()
                      );
                    }
                  },
                ),
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
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Trending",
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 4,
                            scrollDirection: Axis.vertical,
                            physics: PageScrollPhysics(),
                            shrinkWrap: true,
                            children:
                            List.generate(snapshot.data!.length, (index) {
                              return buildRowItemsGrid(context, recipe[index]);
                            })),
                      )
                    ]);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
