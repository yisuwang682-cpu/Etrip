import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/utils/assets.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Chatbot extends StatelessWidget {
  const Chatbot({super.key});

  @override
  Widget build(BuildContext context) {
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
            "How can i help you?",
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
                "Start New Chat",
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
