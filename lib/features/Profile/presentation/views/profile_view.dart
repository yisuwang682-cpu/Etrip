import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/Profile/bloc/user_bloc.dart';
import 'package:egyptopia/features/Profile/bloc/user_state.dart';
import 'package:egyptopia/features/Profile/presentation/views/widgets/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
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
          if (state is UserError) {
            return Center(child: Text(state.error));
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No Profile Data!",
                  style: GoogleFonts.lato(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const VerticalSpace(1),
                CustomJoinButton(
                    text: "Please Go to Login",
                    onTap: () {
                      GoRouter.of(context).pushReplacement(AppRouter.kSignIn);
                    })
              ],
            ),
          );
        },
      ),
    );
  }
}
