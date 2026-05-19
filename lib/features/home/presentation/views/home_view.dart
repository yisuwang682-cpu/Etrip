import 'package:etrip/core/constants.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/features/home/presentation/views/widgets/home_body.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableScreen(
      gradientStops: [0,0.6],
      backgroundColor: kSecondaryColor,
        imageColor: Colors.black, child: HomeBody());
  }
}
