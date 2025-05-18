import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:flutter/material.dart';

class ItineraryView extends StatelessWidget {
  const ItineraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableScreen(
      gradientStops: [0, 0.6],
      backgroundColor: kSecondaryColor,
      imageColor: Colors.black,
      child: Center(
        child: Text(
          "Welcome to Itinerary!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
