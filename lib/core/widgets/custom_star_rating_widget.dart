import 'package:flutter/material.dart';

class CustomStarRatingWidget extends StatelessWidget {
  final double rating;
  final double iconSize;

  const CustomStarRatingWidget({
    super.key,
    required this.rating,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        if (rating >= index + 1) {
          return Icon(Icons.star, size: iconSize, color: Colors.amber);
        } else if (rating > index && rating < index + 1) {
          return Icon(Icons.star_half, size: iconSize, color: Colors.amber);
        } else {
          return Icon(Icons.star_border, size: iconSize, color: Colors.amber);
        }
      }),
    );
  }
}