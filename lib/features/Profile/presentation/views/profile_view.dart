import 'package:etrip/core/utils/app_router.dart';
import 'package:etrip/core/widgets/custom_buttons.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/Profile/bloc/user_bloc.dart';
import 'package:etrip/features/Profile/bloc/user_state.dart';
import 'package:etrip/features/Profile/presentation/views/widgets/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return ReusableScreen(
      imageColor: const Color(0xFF999EB9),
      backgroundColor: const [Colors.white, Colors.white],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserLoaded) {
            return ProfileContent(user: state.user);
          }
          if (state is UserUnauthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Translations.tr('no_profile_data', lang),
                    style: GoogleFonts.lato(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const VerticalSpace(1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 95),
                    child: CustomGeneralButton(
                        text: Translations.tr('please_sign_in_first', lang),
                        onTap: () {
                          GoRouter.of(context)
                              .pushReplacement(AppRouter.kSignIn);
                        }),
                  )
                ],
              ),
            );
          }
          if (state is UserError) {
            return Center(child: Text(state.error));
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Translations.tr('no_profile_data', lang),
                  style: GoogleFonts.lato(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const VerticalSpace(1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 95),
                  child: CustomGeneralButton(
                      text: Translations.tr('please_log_in_first', lang),
                      onTap: () {
                        GoRouter.of(context).pushReplacement(AppRouter.kSignIn);
                      }),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
