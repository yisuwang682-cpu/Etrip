import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/utils/assets.dart';
import 'package:flutter/material.dart';

class ReusableScreen extends StatelessWidget {
  final Widget child;
  final List<Color>? backgroundColor;
  final List<double>? gradientStops;
  final Color? imageColor;

  const ReusableScreen({
    super.key,
    required this.child,
    this.imageColor = Colors.white,
    this.backgroundColor = konBordingColor,
    this.gradientStops,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundColor!,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: gradientStops ?? [0.25, 0.6],
          ),
        ),
        child: Stack(
          children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Image.asset(AssetsData.vectors,color: imageColor,),
              ),
            child,
          ],
        ),
      ),
    );
  }
}
