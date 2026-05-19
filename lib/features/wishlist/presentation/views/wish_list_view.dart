import 'package:etrip/core/constants.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/utils/size_config.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/wishlist/data/model/favorite_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/favorite_card.dart';

class WishListView extends StatefulWidget {
  const WishListView({super.key});

  @override
   State<WishListView> createState() => _WishListViewState();
}

class _WishListViewState extends State<WishListView> {
  int selectedIndex = 0;

  final tabs = [
    FavoriteType.place,
    FavoriteType.activity,
    FavoriteType.event,
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return Scaffold(
      body: ReusableScreen(
        backgroundColor: kSecondaryColor,
        imageColor: Colors.black,
        gradientStops: const [0.1, 0.7],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const VerticalSpace(4),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  Translations.tr('favorites_title', lang),
                  style: TextStyle(
                    fontSize: SizeConfig.defaultSize! * 3.25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        offset: Offset(3, 3),
                        blurRadius: 4,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalSpace(1),
              ToggleButtons(
                color: Colors.white,
                selectedColor: Colors.black,
                borderColor: Colors.white,
                borderRadius: BorderRadius.circular(8),
                borderWidth: 1.5,
                fillColor: Colors.white,
                selectedBorderColor: Colors.white,
                textStyle: GoogleFonts.inter(
                    fontSize: 16, fontWeight: FontWeight.w600),
                constraints: BoxConstraints(
                  minWidth: SizeConfig.screenWidth! * 0.29,
                  minHeight: SizeConfig.defaultSize! * 4.25,
                ),
                isSelected: List.generate(
                    tabs.length, (index) => index == selectedIndex),
                onPressed: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                children: [
                  Text(Translations.tr('places_tab', lang)),
                  Text(Translations.tr('activities_tab', lang)),
                  Text(Translations.tr('events_tab', lang)),
                ],
              ),
              Expanded(
                child: FavoriteCard(type: tabs[selectedIndex]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
