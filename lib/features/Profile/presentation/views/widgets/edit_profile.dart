import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:egyptopia/core/widgets/custom_fields.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/Profile/bloc/user_bloc.dart';
import 'package:egyptopia/features/Profile/bloc/user_event.dart';
import 'package:egyptopia/features/Profile/presentation/views/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:egyptopia/features/auth/data/models/egyptopia_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatefulWidget {
  final EgyptopiaUser user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  late TextEditingController countryController;
  late TextEditingController genderController;
  late TextEditingController dateOfBirthController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    countryController = TextEditingController(text: widget.user.country ?? '');
    genderController = TextEditingController(text: widget.user.gender ?? '');
    dateOfBirthController =
        TextEditingController(text: widget.user.dateOfBirth ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();
    genderController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReusableScreen(
      imageColor: const Color(0xFF999EB9),
      backgroundColor: const [Colors.white, Colors.white],
      showBackButton: true,
      iconColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
                child: Text(
              "Edit Profile",
              style: GoogleFonts.inter(
                  color: const Color(0xFF1F2544),
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            )),
            const VerticalSpace(1),
            ProfileImage(
              imageUrl: widget.user.profileImg,
              userId: widget.user.id,
              onImageChanged: (_) async{
                context.read<UserBloc>().add(LoadUser(widget.user.id));
              },
            ),
            const VerticalSpace(1),
            CustomInputField(
              label: "Email (can't edit)",
              hint: "",
              controller: TextEditingController(text: widget.user.email),
              enabled: false,
            ),
            const VerticalSpace(1),
            CustomInputField(
              label: "Name",
              hint: "Enter Your Name",
              controller: nameController,
            ),
            const VerticalSpace(1),
            CustomInputField(
              controller: countryController,
              label: "Country",
              hint: countryController.text,
              onChanged: (val) {
                countryController.text = val;
              },
              isCountryPicker: true,
            ),
            const VerticalSpace(1),
            CustomInputField(
              label: "Gender",
              hint: genderController.text,
              controller: genderController,
              onChanged: (val) {
                genderController.text = val;
              },
              isDropdown: true,
            ),
            const VerticalSpace(1),
            CustomInputField(
              label: "Date Of Birth",
              hint: dateOfBirthController.text,
              controller: dateOfBirthController,
              onChanged: (val) {
                dateOfBirthController.text = val;
              },
              isDatePicker: true,
            ),
            const VerticalSpace(1),
            CustomGeneralButton(
                onTap: () async {
                  final updatedUser = EgyptopiaUser(
                    id: widget.user.id,
                    email: widget.user.email,
                    name: nameController.text.trim(),
                    country: countryController.text.trim(),
                    gender: genderController.text.trim(),
                    dateOfBirth: dateOfBirthController.text.trim(),
                    profileImg: widget.user.profileImg,
                  );
                  context.read<UserBloc>().add(UpdateUser(updatedUser));
                  GoRouter.of(context).pop();
                },
                text: "Save Changes"),
          ],
        ),
      ),
    );
  }
}
