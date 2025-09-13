// ignore_for_file: avoid_print

import 'package:recipe/utils/export.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> getUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    return doc.data()?['username'];
  }

  Stream<QuerySnapshot> getRecipes() {
    return FirebaseFirestore.instance
        .collection('recipes')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  List<Widget> tabs = [
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("All", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("Indian", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("Italian", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("German", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("Turkis", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("Chinese", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
    Tab(
      child: Row(
        children: [
          Container(width: 10),
          textBold("Korean", 14),
          const SizedBox(width: 8),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // textBold("🌤️ Good Morning ", 18),
                      // textBold("☀️ Good Afternoon ", 18),
                      // textBold("✨️ Good Evening ", 18),
                      // textBold("Hello \$name", 28),
                      FutureBuilder<String?>(
                        future: getUsername(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return textBold("Hello ...", 28); // loading state
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return textBold("Hello Guest", 28); // fallback
                          }
                          return textBold("Hello ${snapshot.data}", 28);
                        },
                      ),
                      textRegular(
                        "What are you cooking today?",
                        18,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Signed is with Google Successfully!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    },
                    child: Icon(Icons.search, size: 34, color: grey),
                  ),
                ],
              ),
              // Search and filter
              SizedBox(height: 20),
              SingleChildScrollView(
                // Edit
                padding: EdgeInsetsDirectional.only(start: 15),
                scrollDirection: Axis.horizontal,
                child: DefaultTabController(
                  length: 7,
                  child: Row(
                    children: [
                      ButtonsTabBar(
                        unselectedBackgroundColor: Colors.transparent,
                        unselectedLabelStyle: TextStyle(color: grey),
                        radius: 12,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        backgroundColor: primaryColor,
                        buttonMargin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        labelStyle: TextStyle(color: whiteColor),
                        tabs: tabs,
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: getRecipes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return noRecipesFound();
                  }

                  final recipes = snapshot.data!.docs;

                  return SingleChildScrollView(
                    padding: const EdgeInsetsDirectional.only(start: 17),
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 38,
                        horizontal: 12,
                      ),
                      child: Row(
                        children:
                            recipes.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => IngridentPage(
                                                imagePath: "assets/r1.png",
                                                title: data['name'],
                                                creator: data['username'],
                                                time: data['estimatedtime'],
                                                rating:
                                                    double.tryParse(
                                                      data['ratings']
                                                          .toString(),
                                                    ) ??
                                                    0.0,

                                                nutritions: data['nutritions'],
                                                ingredients:
                                                    data['ingredients'],
                                                instructions:
                                                    data['instructions'],
                                                recipeId: data['recipeId'],
                                                userId: data['userId'],
                                              ),
                                        ),
                                      );
                                    },
                                    child: FoodCard(
                                      imagePath: "assets/r1.png",
                                      // data['imageUrl'] ?? "assets/r1.png",
                                      title: data['name'] ?? 'No name',
                                      time:
                                          (data['estimatedtime'] ?? '')
                                              .toString(),
                                      rating: (data['rating'] ?? 0).toDouble(),
                                      recipeId: data['recipeId'] ?? 'No name',
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  // Text(data['recipeId']),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 5),
                  child: textBold("New Recipes", 22),
                ),
              ),
              // New Recipe
              StreamBuilder(
                stream: getRecipes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return noNewRecipesFound();
                  }

                  final recipes = snapshot.data!.docs;
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children:
                            recipes.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return Row(
                                children: [
                                  RecipeCard(
                                    imagePath: "assets/r1.png",
                                    // data['imageUrl'] ?? "assets/r1.png",
                                    title: data['name'] ?? 'No name',
                                    time:
                                        (data['estimatedtime'] ?? '')
                                            .toString(),
                                    rating: (data['rating'] ?? 0).toDouble(),
                                    uploadedby: data['username'] ?? 'Unknown',
                                  ),
                                  SizedBox(height: 10),
                                ],
                              );
                            }).toList(),

                        // SizedBox(width: 8),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
