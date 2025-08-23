import 'package:recipe/utils/export.dart';

class RecipeCard extends StatelessWidget {
  final String imagePath;
  final String uploadedby;
  final String title;
  final String time;
  final double rating;

  const RecipeCard({
    super.key,
    required this.imagePath,
    required this.uploadedby,
    required this.title,
    required this.time,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 185,
            // width: MediaQuery.of(context).size.width * 0.7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                margin: EdgeInsets.only(top: 50),
                padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(227, 255, 255, 255),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 230,
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: grey1,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.orange),
                        SizedBox(width: 3),
                        Icon(Icons.star, size: 16, color: Colors.orange),
                        SizedBox(width: 3),
                        Icon(Icons.star, size: 16, color: Colors.orange),
                        SizedBox(width: 3),
                        Icon(Icons.star, size: 16, color: Colors.orange),
                        SizedBox(width: 3),
                        Icon(Icons.star, size: 16, color: Colors.orange),
                        SizedBox(width: 3),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: Image.asset(
                                imagePath,
                                height: 30,
                                width: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 4),
                            textBold(uploadedby, 14, color: grey3),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.timer_sharp, color: grey3),
                            textRegular(" $time Mins", 14, color: grey3),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Image with rating badge
          Positioned(
            top: 6,
            right: 40,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Image.asset(
                    imagePath,
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                // Positioned(
                //   top: -5,
                //   right: -5,
                //   child: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //     decoration: BoxDecoration(
                //       color: Color(0xffFFE9CA),
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     child: Row(
                //       children: [
                //         Icon(Icons.star, size: 16, color: Colors.orange),
                //         SizedBox(width: 3),
                //         Text(
                //           rating.toString(),
                //           style: GoogleFonts.poppins(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 13,
                //             color: Colors.black,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
