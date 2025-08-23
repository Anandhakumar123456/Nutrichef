import 'package:recipe/utils/export.dart';

class FoodCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String time;
  final double rating;
  final String recipeId;

  const FoodCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.time,
    required this.rating,
    required this.recipeId,
  });

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkIfSaved() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

    if (userDoc.exists) {
      List<dynamic> savedRecipes = userDoc.data()?["savedRecipes"] ?? [];
      setState(() {
        isSaved = savedRecipes.contains(widget.recipeId);
      });
    }
  }

  Future<void> _toggleSave() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid);

    if (isSaved) {
      // remove from savedRecipes
      await userRef.update({
        "savedRecipes": FieldValue.arrayRemove([widget.recipeId]),
      });
    } else {
      // add to savedRecipes
      await userRef.update({
        "savedRecipes": FieldValue.arrayUnion([widget.recipeId]),
      });
      showSuccessSnackBar(context, 'Recipe saved successfully');
    }

    setState(() {
      isSaved = !isSaved; // toggle state locally
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Example for create positioned image and container
          SizedBox(
            height: 230,
            child: Container(
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.fromLTRB(16, 60, 16, 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: grey1,
                    ),
                  ),
                  SizedBox(height: 6),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textBold("Time", 12, color: grey3),
                          textBold("${widget.time} Mins", 14, color: grey1),
                        ],
                      ),
                      GestureDetector(
                        onTap: _toggleSave,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            "assets/icons/bookmark.png",
                            color: isSaved ? primaryColor : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Image with rating badge
          Positioned(
            top: 0,
            left: 30,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Image.asset(
                    widget.imagePath,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xffFFE9CA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.orange),
                        SizedBox(width: 3),
                        textBold(widget.rating.toString(), 13),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
