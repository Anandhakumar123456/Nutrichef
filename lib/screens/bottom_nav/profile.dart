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

  Widget _buildTabButton(String text, int index) {
    final bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: textBold(
            text,
            14,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/r1.png"),
                  ),
                  Column(
                    children: [
                      textRegular("Recipe", 14, color: grey3),
                      textBold("23", 24),
                    ],
                  ),
                  Column(
                    children: [
                      textRegular("Followers", 14, color: grey3),
                      textBold("45M", 24),
                    ],
                  ),
                  Column(
                    children: [
                      textRegular("Following", 14, color: grey3),
                      textBold("245", 24),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // textBold("Michael Smith", 24),
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
              Row(
                children: [
                  _buildTabButton("Recipes", 0),
                  _buildTabButton("Videos", 1),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }
}
