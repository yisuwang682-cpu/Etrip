import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/custom_fields.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:egyptopia/features/onbording/presentation/views/widgets/page_view_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return "No user logged in!";

      // عمل re-authenticate بالباسورد القديم
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // تغيير الباسورد للباسورد الجديد
      await user.updatePassword(newPassword);
      return null; // يعني success!
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return "Old password is incorrect!";
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void onChangePasswordTap(BuildContext context) async {
    final oldPw = oldPasswordController.text.trim();
    final newPw = newPasswordController.text.trim();
    final confirmPw = confirmPasswordController.text.trim();

    if (oldPw.isEmpty || newPw.isEmpty || confirmPw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all fields!")),
      );
      return;
    }
    if (newPw != confirmPw) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }
    setState(() => _loading = true);

    final error = await changePassword(currentPassword: oldPw, newPassword: newPw);
    setState(() => _loading = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully! Please log in again.")),
      );
      GoRouter.of(context).pushReplacement(AppRouter.kSignIn);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReusableScreen(
      showBackButton: true,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
              child: Column(
                children: [
                  const VerticalSpace(4),
                  Text(
                    "Create New Password",
                    style: GoogleFonts.imFellFrenchCanon(
                      fontSize: SizeConfig.defaultSize! * 3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VerticalSpace(2),
                  const PageViewItem(
                    image: 'assets/images/new1.png',
                    title:
                        'Your new password must be different\nfrom previously used password',
                    subTitle: '',
                    titleFontSize: 18,
                    subTitleFontSize: 1,
                  ),
                  CustomInputField(
                    controller: oldPasswordController,
                    label: "Old Password",
                    hint: "Enter Your Old Password",
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                  ),
                  const VerticalSpace(2),
                  CustomInputField(
                    controller: newPasswordController,
                    label: "New Password",
                    hint: "Enter Your New Password",
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                  ),
                  const VerticalSpace(2),
                  CustomInputField(
                    controller: confirmPasswordController,
                    label: "Confirm Password",
                    hint: "Re-enter Your Password",
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomGeneralButton(
                      text: _loading ? "Processing..." : "Confirm",
                      onTap: _loading ? null : () => onChangePasswordTap(context),
                    ),
                  ),
                ],
              ),
            ),
            if (_loading)
              Container(
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}