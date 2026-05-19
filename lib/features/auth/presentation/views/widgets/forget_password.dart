import 'package:etrip/core/utils/size_config.dart';
import 'package:etrip/core/widgets/custom_fields.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/auth/data/logic/sign_in_controller.dart';
import 'package:etrip/features/onbording/presentation/views/widgets/page_view_item.dart';
import 'package:flutter/material.dart';
import 'package:etrip/core/widgets/custom_buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final lang = context.watch<LocaleCubit>().state.languageCode;
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
                    Translations.tr('verify_your_email', lang),
                    style: GoogleFonts.imFellFrenchCanon(
                      fontSize: SizeConfig.defaultSize! * 3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VerticalSpace(3),
                  PageViewItem(
                    image: 'assets/images/forgot.png',
                    title: Translations.tr('enter_email_address', lang),
                    subTitle: Translations.tr('we_will_verify_email', lang),
                    titleFontSize: SizeConfig.defaultSize! * 2.6,
                    subTitleFontSize: SizeConfig.defaultSize! * 1.6,
                  ),
                  const VerticalSpace(3),
                  CustomInputField(
                    label: Translations.tr('email', lang),
                    hint: Translations.tr('enter_your_email', lang),
                    inputType: TextInputType.emailAddress,
                    controller: _controller.emailController,
                  ),
                  const VerticalSpace(3),
                  CustomGeneralButton(
                    text: Translations.tr('send', lang),
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
