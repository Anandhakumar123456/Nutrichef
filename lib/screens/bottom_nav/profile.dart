// ignore_for_file: avoid_print

import 'package:recipe/utils/export.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isExpanded = false;
  final int _maxLines = 2;
  int selectedIndex = 0;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
  }

  Widget buildRecipeCount(String currentuserid) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection("recipes")
              .where("userId", isEqualTo: currentuserid)
              .snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return Column(
            children: [
              textRegular("Recipe", 14, color: grey3),
              textBold("0", 24),
            ],
          );
        }
        final recipeCount = snapshots.data!.docs.length;
        return Column(
          children: [
            textRegular("Recipe", 14, color: grey3),
            textBold(recipeCount.toString(), 24),
          ],
        );
      },
    );
  }

  // Widget _buildTabButton(String text, int index) {
  //   final bool isSelected = selectedIndex == index;
  //   return Expanded(
  //     child: GestureDetector(
  //       onTap: () {
  //         setState(() {
  //           selectedIndex = index;
  //         });
  //       },

  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: 12),
  //         decoration: BoxDecoration(
  //           color: isSelected ? primaryColor : Colors.transparent,
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         alignment: Alignment.center,
  //         child: textBold(
  //           text,
  //           14,
  //           color: isSelected ? Colors.white : Colors.black87,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SignInPage()),
            (route) => false,
          );
        }
        if (state is AuthError) {
          showErrorSnackBar(context, state.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert_sharp, color: Colors.red),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
          title: textBold("Profile", 24),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: getUserStream(),
                builder: (context, snapshot) {
                  final userData = snapshot.data!.data()!;
                  final followers = (userData["followers"] ?? []) as List;
                  final following = (userData["following"] ?? []) as List;
                  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("assets/r1.png"),
                        ),
                        buildRecipeCount(currentUserId),
                        Column(
                          children: [
                            textRegular("Followers", 14, color: grey3),
                            textBold("24M", 24),
                          ],
                        ),
                        Column(
                          children: [
                            textRegular("Following", 14, color: grey3),
                            textBold("5", 24),
                          ],
                        ),
                      ],
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/r1.png"),
                      ),
                      buildRecipeCount(currentUserId),
                      Column(
                        children: [
                          textRegular("Followers", 14, color: grey3),
                          textBold("${followers.length}", 24),
                        ],
                      ),
                      Column(
                        children: [
                          textRegular("Following", 14, color: grey3),
                          textBold("${following.length}", 24),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String?>(
                    future: getUsername(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return textBold("...", 28); // loading state
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return textBold("Guest", 28); // fallback
                      }
                      return textBold("${snapshot.data}", 28);
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Private chef with a passion for creating delicious and healthy meals. Follow me for recipes and cooking tips!",
                    maxLines: _isExpanded ? null : _maxLines,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: grey3,
                    ),
                  ),
                  SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: textRegular(
                      _isExpanded ? 'Show less' : 'More...',
                      13,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Row(
              //   children: [
              //     _buildTabButton("Recipes", 0),
              //     _buildTabButton("Videos", 1),
              //   ],
              // ),
              // SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('recipes')
                          .where(
                            'userId',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                          )
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No recipes uploaded yet"),
                      );
                    }

                    final recipes = snapshot.data!.docs;

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 1.9,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final data =
                            recipes[index].data()! as Map<String, dynamic>;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => IngridentPage(
                                      imagePath:
                                          data['imagePath'] ?? 'assets/r2.png',
                                      time: data['estimatedtime'] ?? '0',
                                      title: data['name'] ?? 'Untitled',
                                      rating: data['ratings'] ?? 0,
                                      creator: data['username'] ?? 'Unknown',
                                      nutritions: Map<String, dynamic>.from(
                                        data['nutritions'] ?? {},
                                      ),

                                      ingredients:
                                          List<Map<String, dynamic>>.from(
                                            data['ingredients'] ?? [],
                                          ),
                                      instructions: List<String>.from(
                                        data['instructions'] ?? [],
                                      ),
                                      recipeId: data['recipeId'] ?? "",
                                      userId: data['userId'] ?? "",
                                    ),
                              ),
                            );
                          },
                          child: SavedRecipes(
                            imagePath:
                                data['imageUrlj'] ??
                                'assets/r1.png', // Edit in the future imageurl J
                            title: data['name'] ?? '',
                            rating: data['ratings'] ?? "0",
                            creator: data['uploadedby'] ?? '',
                            time: data['estimatedtime'] ?? '',
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
