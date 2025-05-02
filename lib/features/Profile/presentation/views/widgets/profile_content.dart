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
            const HorizantalSpace(2),
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
            icon: const Icon(Icons.room_preferences_outlined),
            text: "My Prefrence",
            onTap: () {}),
        CustomCard(
            icon: const Icon(Icons.photo_size_select_actual_rounded),
            text: "Travel photos",
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
