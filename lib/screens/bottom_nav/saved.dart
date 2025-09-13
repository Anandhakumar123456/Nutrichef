// ignore_for_file: avoid_print

import 'package:recipe/utils/export.dart';

class SavedRecipePage extends StatefulWidget {
  const SavedRecipePage({super.key});

  @override
  State<SavedRecipePage> createState() => _SavedRecipePageState();
}

class _SavedRecipePageState extends State<SavedRecipePage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<DocumentSnapshot>> _getSavedRecipes() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .asyncMap((userDoc) async {
          final savedIds = List<String>.from(
            userDoc.data()?['savedRecipes'] ?? [],
          );
          print("Saved recipe IDs: $savedIds");
          if (savedIds.isEmpty) return [];

          final recipesSnap =
              await FirebaseFirestore.instance
                  .collection('recipes')
                  .where(FieldPath.documentId, whereIn: savedIds)
                  .get();

          return recipesSnap.docs;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: textBold("Saved Recipes", 22),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: _getSavedRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No saved recipes yet 😔"));
          }

          final savedRecipes = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: GridView.count(
              crossAxisCount: 1,
              childAspectRatio: 1.9,
              mainAxisSpacing: 12,
              children:
                  savedRecipes.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => IngridentPage(
                                  imagePath:
                                      data['imagePath'] ?? 'assets/r2.png',
                                  time: data['estimatedtime'] ?? '0',
                                  title: data['name'] ?? 'Untitled',
                                  rating: (data['ratings'] ?? 0).toDouble(),
                                  creator: data['username'] ?? 'Unknown',
                                  nutritions: Map<String, dynamic>.from(
                                    data['nutritions'] ?? {},
                                  ),

                                  ingredients: List<Map<String, dynamic>>.from(
                                    data['ingredients'] ?? [],
                                  ),
                                  instructions: List<String>.from(
                                    data['instructions'] ?? [],
                                  ),
                                  recipeId: doc.id,
                                  userId: data['userId'] ?? 'Unknown',
                                ),
                          ),
                        );
                      },
                      child: SavedRecipes(
                        imagePath: data['imagePath'] ?? 'assets/r1.png',
                        title: data['name'] ?? 'No title',
                        rating: (data['ratings'] ?? 0).toDouble(),
                        creator: data['username'] ?? 'Unknown',
                        time: data['estimatedtime'] ?? '0',
                      ),
                    );
                  }).toList(),
            ),
          );
        },
      ),
    );
  }
}
