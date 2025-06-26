// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:recipe/screens/ingrident.dart';
import 'package:recipe/utils/saved_recipes.dart';
import 'package:recipe/utils/widgets.dart';

class SavedRecipePage extends StatefulWidget {
  const SavedRecipePage({super.key});

  @override
  State<SavedRecipePage> createState() => _SavedRecipePageState();
}

class _SavedRecipePageState extends State<SavedRecipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: textBold("Saved Recipes", 22),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 1.9,
                mainAxisSpacing: 12,
                children: List.generate(7, (index) {
                  return GestureDetector(
                    onTap: () {
                      print("Clicked the $index item ========");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => IngridentPage(
                                imagePath: 'assets/r2.png',
                                time: ' ${index + 10}',
                                title: 'Traditional ribs #$index',
                                rating: 4.0 + (index % 5) * 0.1,
                                creator: 'Anand',
                              ),
                        ),
                      );
                    },
                    child: SavedRecipes(
                      imagePath: 'assets/r1.png',
                      title: 'Traditional ribs #$index',
                      rating: 4.0 + (index % 5) * 0.1,
                      creator: 'Anand',
                      time: '20',
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
