// ignore_for_file: deprecated_member_use

import 'package:recipe/utils/export.dart';

class RecipeCardSquare extends StatefulWidget {
  final String imagePath;
  final String title;
  final String creator;
  final double rating;

  const RecipeCardSquare({
    super.key,
    required this.imagePath,
    required this.title,
    required this.rating,
    required this.creator,
  });

  @override
  State<RecipeCardSquare> createState() => _RecipeCardSquareState();
}

class _RecipeCardSquareState extends State<RecipeCardSquare> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 200,
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
          width: 200,
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
          top: 10,
          right: 10,
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
      ],
    );
  }
}
