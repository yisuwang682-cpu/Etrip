import 'package:etrip/core/constants.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/utils/app_router.dart';
import 'package:etrip/core/utils/assets.dart';
import 'package:etrip/core/utils/size_config.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Chatbot extends StatelessWidget {
  const Chatbot({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return ReusableScreen(
      showBackButton: true,
      backgroundColor: kMainColor,
      gradientStops: const [0.1, 0.7],
      imageColor: Colors.black,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            AssetsData.chatbot,
            height: SizeConfig.defaultSize! * 30,
          ),
          Text(
            Translations.tr('chatbot_greeting', lang),
            style: TextStyle(
              fontSize: SizeConfig.defaultSize! * 3,
              color: Colors.white,
            ),
          ),
          const VerticalSpace(2),
          Center(
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).push(AppRouter.kChatDetails);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              ),
              child: Text(
                Translations.tr('start_new_chat', lang),
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
