import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class FeatureSection extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final VoidCallback onSeeAll;
  final Widget slider;

  const FeatureSection({
    super.key,
    required this.title,
    this.titleStyle,
    required this.onSeeAll,
    required this.slider,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: titleStyle ??
                  GoogleFonts.merriweather(
                    color: const Color(0xFF1F2544),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                Translations.tr('see_all', lang),
                style: GoogleFonts.merriweather(
                  color: Colors.black,
                  shadows: [
                    const Shadow(
                      color: Colors.white,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        slider,
      ],
    );
  }
}
