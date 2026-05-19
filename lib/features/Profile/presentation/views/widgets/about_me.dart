import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:etrip/core/widgets/custom_fields.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:etrip/features/auth/data/models/egyptopia_user.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutMe extends StatefulWidget {
  final EgyptopiaUser user;
  const AboutMe({super.key, required this.user});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
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
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return ReusableScreen(
      imageColor: const Color(0xFF999EB9),
      backgroundColor: const [Colors.white, Colors.white],
      showBackButton: true,
      iconColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const VerticalSpace(8),
            Center(
                child: Text(
              Translations.tr('about_me_title', lang),
              style: GoogleFonts.inter(
                  color: const Color(0xFF1F2544),
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )),
            const VerticalSpace(1),
            CustomInputField(
              label: Translations.tr('email', lang),
              hint: "",
              controller: TextEditingController(text: widget.user.email),
              enabled: false,
            ),
            const VerticalSpace(1),
            CustomInputField(
              label: Translations.tr('name', lang),
              hint: Translations.tr('enter_your_name', lang),
              enabled: false,
              controller: nameController,
            ),
            const VerticalSpace(1),
            CustomInputField(
              controller: countryController,
              label: Translations.tr('country', lang),
              hint: countryController.text,
              enabled: false,
            ),
            const VerticalSpace(1),
            CustomInputField(
              label: Translations.tr('gender', lang),
              hint: genderController.text,
              controller: genderController,
              enabled: false,
            ),
            const VerticalSpace(1),
            CustomInputField(
              label: Translations.tr('date_of_birth', lang),
              hint: dateOfBirthController.text,
              controller: dateOfBirthController,
              enabled: false,
            ),
            const VerticalSpace(1),
          ],
        ),
      ),
    );
  }
}
