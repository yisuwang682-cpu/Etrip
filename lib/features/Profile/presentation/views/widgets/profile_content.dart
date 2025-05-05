// ignore_for_file: use_build_context_synchronously

import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:egyptopia/core/widgets/custom_card.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/Profile/bloc/user_bloc.dart';
import 'package:egyptopia/features/Profile/bloc/user_event.dart';
import 'package:egyptopia/features/Profile/presentation/views/widgets/profile_image.dart';
import 'package:egyptopia/features/auth/data/models/egyptopia_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key, required this.user});
  final EgyptopiaUser user;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VerticalSpace(10),
        Row(
          children: [
            const HorizantalSpace(2),
            ProfileImage(
              imageUrl: user.profileImg,
              userId: user.id,
              onImageChanged: (_) {
                context.read<UserBloc>().add(LoadUser(user.id));
              },
            ),
            const HorizantalSpace(3),
            Column(
              children: [
                Text(
                  user.name,
                  style: GoogleFonts.inter(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  user.email,
                  style: GoogleFonts.inter(
                      color: const Color(0xFF8E8E8E),
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
                CustomJoinButton(
                  text: "Edit Profile",
                  onTap: () {
                    GoRouter.of(context)
                        .push(AppRouter.kEditProfile, extra: user);
                  },
                  fontSize: 11,
                  minimumSize: const Size(90, 30),
                )
              ],
            ),
          ],
        ),
        const VerticalSpace(2),
        CustomCard(
            icon: const Icon(Icons.favorite_border),
            text: "Favourites",
            onTap: () {
              GoRouter.of(context).push(AppRouter.kWishList);
            }),
        CustomCard(
            icon: const Icon(Icons.account_box_outlined),
            text: "About me",
            onTap: () {
              GoRouter.of(context).push(AppRouter.kAboutMe, extra: user);
            }),
        CustomCard(
            icon: const Icon(Icons.directions_bike_outlined),
            text: "Edit Prefrence",
            onTap: () {
              GoRouter.of(context).push(AppRouter.kPreferenceOne);
            }),
        CustomCard(
            icon: const Icon(Icons.vpn_key_outlined),
            text: "Change Password",
            onTap: () {
              GoRouter.of(context).push(AppRouter.kCreateNewPassword);
            }),
        CustomCard(
          icon: const Icon(Icons.logout),
          text: "Log Out",
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
            context.read<UserBloc>().add(LogoutUser());
            GoRouter.of(context).pushReplacement(AppRouter.kSignIn);
          },
        ),
      ],
    );
  }
}
