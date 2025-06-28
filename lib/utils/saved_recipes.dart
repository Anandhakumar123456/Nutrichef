// ignore_for_file: deprecated_member_use

import 'package:recipe/utils/export.dart';

class SavedRecipes extends StatefulWidget {
  final String imagePath;
  final String title;
  final String creator;
  final String time;
  final double rating;
  const SavedRecipes({
    super.key,
    required this.imagePath,
    required this.title,
    required this.creator,
    required this.time,
    required this.rating,
  });

  @override
  State<SavedRecipes> createState() => _SavedRecipesState();
}

class _SavedRecipesState extends State<SavedRecipes> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(widget.imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.9), Colors.transparent],
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 12,
          right: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textBold(widget.title, 16, color: whiteColor),
              textRegular(widget.creator, 12, color: Colors.white70),
            ],
          ),
        ),
        Positioned(
          top: 15,
          right: 15,
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
                textBold("${widget.rating}", 13),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: Row(
            children: [
              Icon(Icons.timer_outlined, color: Colors.white),
              SizedBox(width: 6),
              textRegular("${widget.time} Mins", 13, color: whiteColor),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                ),
                child: Image.asset(
                  "assets/icons/bookmark.png",
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
