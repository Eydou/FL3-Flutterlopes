import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_lopes/model/recipe.dart';
import 'package:flutter_app_lopes/widgets/navigation_drawer.dart';
import 'package:flutter_app_lopes/widgets/recipeSearch.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final FloatingSearchBarController controller = FloatingSearchBarController();
  String query = '';

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    Query<Recipe> recipesRef = FirebaseFirestore.instance.collection('recipes')
                        .withConverter<Recipe>(
                          fromFirestore: (snapshots, _) => Recipe.fromJson(snapshots.data()!),
                          toFirestore: (recipe, _) => recipe.toJson(),
                        );

    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Center(child: Text("Search our recipes", style: TextStyle(color: Colors.black))),
    ),
        drawer: const NavigationDrawerLopes(),
        body: StreamBuilder<QuerySnapshot<Recipe>>(
          stream: recipesRef.snapshots(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return Center(
                child: Text("Loading..."),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final List<QueryDocumentSnapshot<Recipe>> ?recipes = snapshot.data?.docs.toList();

            return FloatingSearchBar(
              hint: 'Search recipes',
              controller: controller,
              scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
              transitionDuration: const Duration(milliseconds: 800),
              transitionCurve: Curves.easeInOut,
              physics: const BouncingScrollPhysics(),
              axisAlignment: isPortrait ? 0.0 : -1.0,
              openAxisAlignment: 0.0,
              width: isPortrait ? 600 : 500,
              debounceDelay: const Duration(milliseconds: 500),
              onQueryChanged: (newQuery) {
                setState(() {
                  query = newQuery;
                });
              },
              transition: CircularFloatingSearchBarTransition(),
              progress: !snapshot.hasData,
              actions: [
                FloatingSearchBarAction(
                  showIfOpened: false,
                  child: CircularButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () {},
                  ),
                ),
                FloatingSearchBarAction.searchToClear(
                  showIfClosed: false,
                ),
              ],
              builder: (context, transition) {
                return Container(
                    color: Colors.white,
                    child: ListView(
                      shrinkWrap: true,
                      children: recipeSearchfromList(recipes, query),
                    )
                );
              },
            );
          }),
    );
  }
}