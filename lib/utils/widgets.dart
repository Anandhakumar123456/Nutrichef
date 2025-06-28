import 'package:recipe/utils/export.dart';

Widget buildNutrientItem(String imagePath, String label) {
  return SizedBox(
    width: 140,
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: grey2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: 12),
        Expanded(child: textBold(label, 12)),
      ],
    ),
  );
}

Widget recipeItem(String imagePath, String title, String quantity) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      decoration: BoxDecoration(
        color: grey2,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Image.asset(
                      imagePath,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 6),
              textBold(title, 16),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: textBold(quantity, 12, color: grey3),
          ),
        ],
      ),
    ),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: textBold(message, 16, color: whiteColor)),
        ],
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    ),
  );
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: textBold(message, 16, color: whiteColor)),
        ],
      ),
      backgroundColor: primaryColor,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    ),
  );
}

class BottomSheetScrollableContainer extends StatelessWidget {
  const BottomSheetScrollableContainer({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
    this.scrollController,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: scrollController,
        padding: padding,
        child: ListBody(children: children),
      ),
    );
  }
}

Widget primaryButton(String text, VoidCallback onTap, bool suffixIcon) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onTap,
      child:
          suffixIcon
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  textBold(text, 20, color: whiteColor),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ],
              )
              : textBold(text, 20, color: whiteColor),
    ),
  );
}

Widget textBold(String text, double fontSize, {Color color = Colors.black}) {
  return Text(
    text,
    style: GoogleFonts.poppins(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget textRegular(
  String text,
  double fontSize, {
  Color color = Colors.black,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return Text(
    text,
    maxLines: 3,
    softWrap: true,
    style: GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color,
    ),
    overflow: overflow,
  );
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email';
  }

  // Basic email pattern
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email address';
  }

  return null;
}
