import 'package:flutter/material.dart';
import 'package:flutter_app_lopes/class/recipe.dart';


class RecipePage extends StatefulWidget {
  final Recipe recipe;
  RecipePage({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Image.network(
                  "https://res.cloudinary.com/hv9ssmzrz/image/fetch/c_fill,f_auto,h_600,q_auto,w_800/https://s3-eu-west-1.amazonaws.com/images-ca-1-0-1-eu/tag_photos/original/2426/plat_principal_flickr_2304576748_f79c906b85_b.jpg",
                  fit: BoxFit.fill),
            ),
            SizedBox(height: 20),
            Text(widget.recipe.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            SizedBox(height: 20),
            Text("Ingredient", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.recipe.steps.length,
              itemBuilder: (context, index) {
                return Ingredients(widget.recipe.ingredients[index]);
              },
            ),
            SizedBox(height: 20),
            Text("Steps", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.recipe.steps.length,
              itemBuilder: (context, index) {
                return Steps((index + 1).toString(), widget.recipe.steps[index]);
              },
            )
          ],
      )
    );
  }
}

Widget Steps(String number, String steps) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text("Step $number", style: TextStyle(fontSize: 18),),
    SizedBox(height: 10),
    Text(steps)
  ],
);

Widget Ingredients(Ingredient ingredient) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text("${ingredient.quantity.toString()}${ingredient.type != null ? ingredient.type : 'x'} ${ingredient.name}", style: TextStyle(fontSize: 18),),
    SizedBox(height: 10),
  ],
);