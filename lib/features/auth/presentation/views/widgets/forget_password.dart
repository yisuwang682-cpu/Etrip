import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/custom_fields.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/auth/data/logic/sign_in_controller.dart';
import 'package:egyptopia/features/onbording/presentation/views/widgets/page_view_item.dart';
import 'package:flutter/material.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final SignInController _controller = SignInController();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _loading,
      child: ReusableScreen(
        showBackButton: true,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
              child: Column(
                children: [
                  const VerticalSpace(5),
                  Text(
                    "Verify Your Email",
                    style: GoogleFonts.imFellFrenchCanon(
                      fontSize: SizeConfig.defaultSize! * 3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VerticalSpace(3),
                  PageViewItem(
                    image: 'assets/images/forgot.png',
                    title: 'Enter your email address',
                    subTitle: 'We will verify this email is yours',
                    titleFontSize: SizeConfig.defaultSize! * 2.6,
                    subTitleFontSize: SizeConfig.defaultSize! * 1.6,
                  ),
                  const VerticalSpace(3),
                  CustomInputField(
                    label: "Email",
                    hint: "Enter Your Email",
                    inputType: TextInputType.emailAddress,
                    controller: _controller.emailController,
                  ),
                  const VerticalSpace(3),
                  CustomGeneralButton(
                    text: "Send",
                    onTap: () {
                      _controller.sendPasswordReset(
                          context, _controller.emailController.text, (isLoading) {
                        setState(() {
                          _loading = isLoading;
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
