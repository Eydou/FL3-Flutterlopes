import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../class/recipe.dart';

class CreateRecipe extends StatefulWidget {
  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  var name = <TextEditingController>[];
  var quantity = <TextEditingController>[];
  var types = <TextEditingController>[];
  var steps = <TextEditingController>[];
  var cards = <Card>[];
  var cardStep = <Card>[];
  final controller = TextEditingController();
  final controllerPeople = TextEditingController();
  final controllerTimes = TextEditingController();
  List<Ingredient> listIngredient = [];
  List<String> listTypes = [];

  Card createCardStep() {
    var nameController = TextEditingController();
    steps.add(nameController);

    return Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text('Etape ${cardStep.length + 1}'),
      TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: '')),
    ]));
  }

  Card createCard() {
    var nameController = TextEditingController();
    var quantityController = TextEditingController();
    var typesController = TextEditingController();
    name.add(nameController);
    quantity.add(quantityController);
    types.add(typesController);

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Text('Ingredient ${cards.length + 1}'),
          TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name')),
          TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp("[0-9]")),
              ],
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantité')),
          TextField(
              controller: typesController,
              decoration: InputDecoration(labelText: 'Types')),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cards.add(createCard());
    cardStep.add(createCardStep());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(20),
              elevation: 0,
            ),
            child: Text('Create recipe'),
            onPressed: () {

              final nameRecipes = controller.text;
              List<String> stepString = [];
              steps.forEach((element) {
                stepString.add(element.text);
              });
              for (int i = 0; i != name.length; i++) {
                listIngredient.add(Ingredient(name: name[i].text, quantity: int.parse(quantity[i].text), type: types[i].text));
              }
              createName(name: nameRecipes, people: int.parse(controllerPeople.text), time: int.parse(controllerTimes.text), steps: stepString, ingredient: listIngredient).then((value) => Navigator.pop(context));
              print("IISISISISI ${controllerTimes.text}");
            },
          ),
        ),
        appBar: AppBar(
          title: Text('Create recipe'),
        ),
        body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: controller.clear,
                          icon: Icon(Icons.clear),
                        ),
                        labelText: "Name",
                        hintText: "Name",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                    onTap: () {},
                  ),
                ),
                TextField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[0-9]")),
                    ],
                    controller: controllerPeople,
                    decoration: InputDecoration(labelText: 'Person')),
                TextField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[0-9]")),
                    ],
                    controller: controllerTimes,
                    decoration: InputDecoration(labelText: 'Time')),
                Text('Ingredients', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cards.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: const EdgeInsets.all(20.0),
                    child:cards[index]);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    child: Text('Add ingredient'),
                    onPressed: () => setState(() => cards.add(createCard())),
                  ),
                ),
                Text('Steps', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cardStep.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: const EdgeInsets.all(20.0),
                    child: cardStep[index]);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    child: Text('Add step'),
                    onPressed: () => setState(() => cardStep.add(createCardStep())),
                  ),
                ),
              ],
            )));
  }
  @override
  void dispose() {
    for (TextEditingController controller in name)
    {
      controller.dispose();
    }
    for (TextEditingController controller in quantity)
    {
      controller.dispose();
    }
    for (TextEditingController controller in types)
    {
      controller.dispose();
    }
    for (TextEditingController controller in steps)
    {
      controller.dispose();
    }
    controller.dispose();
    super.dispose();
  }
}

Future createName({required String name,required int time, required int people, required List<Ingredient> ingredient, required List<String> steps}) async {

  final _firebaseAuth = FirebaseAuth.instance;
  final docName = FirebaseFirestore.instance.collection("recipes").doc();

  final recipe = Recipe(
      userId: _firebaseAuth.currentUser!.uid,
      people: people,
      time: time,
      id: docName.id,
      name: name,
      steps: steps,
      ingredients: ingredient);
  final json = recipe.toJson();

  await docName.set(json);
}
