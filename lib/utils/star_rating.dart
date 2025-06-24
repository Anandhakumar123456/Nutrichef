import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final double initialRating;
  final void Function(double rating) onRatingChanged;
  const StarRating({
    super.key,
    required this.initialRating,
    required this.onRatingChanged,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  double _currentRating = 0.0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  void _updateRating(int rating) {
    setState(() {
      _currentRating = rating.toDouble();
    });
    widget.onRatingChanged(_currentRating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final i = index + 1;
        return GestureDetector(
          onTap: () => _updateRating(i),
          child: Icon(
            i <= _currentRating ? Icons.star : Icons.star_border,
            color: Colors.orange,
            size: 28,
          ),
        );
      }),
    );
  }
}
