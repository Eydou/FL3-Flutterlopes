import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_lopes/model/recipe.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final FloatingSearchBarController controller = FloatingSearchBarController();

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final recipesRef = FirebaseFirestore.instance.collection('recipes')
                        .withConverter<Recipe>(
                          fromFirestore: (snapshots, _) => Recipe.fromJson(snapshots.data()!),
                          toFirestore: (recipe, _) => recipe.toJson(),
                        );

    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text("Search our recipes", style: TextStyle(color: Colors.black)),
    ),
        body: Center(child: StreamBuilder<QuerySnapshot<Recipe>>(
          stream: recipesRef.snapshots(),
          builder: (context, snapshot) {
            print(snapshot.requireData.docs[0]);
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
              //onQueryChanged: model.onQueryChanged,
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
                      //children: List {("yo")},
                    )
                );
              },
            );
          }),
        ),
    );
  }
}