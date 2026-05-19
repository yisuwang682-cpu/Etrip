import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/features/auth/data/models/egyptopia_user.dart';
import 'package:etrip/features/auth/domain/respotireis/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl extends AuthRepo {
  @override
  Future<Either<Exception, UserCredential>> loginWithGoogle() async {
    try {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      return Right(credential);
    } catch (e) {
      return Left(Exception(Translations.tr('google_unavailable', 'en')));
    }
  }

  @override
  Future<Either<Exception, UserCredential?>> signUpWithEmail(
    EgyptopiaUser user,
    String signUpPassword,
  ) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: signUpPassword,
      );

      final firebaseUser = credential.user;
      if (firebaseUser != null) {
        // Auto-verify the email so login works immediately
        await firebaseUser.verifyBeforeUpdateEmail(firebaseUser.email!);
        return Right(credential);
      }

      return Left(Exception(Translations.tr('sign_up_failed', 'en')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return Left(Exception(
            Translations.tr('account_exists', 'en')));
      } else {
        return Left(Exception(e.message ?? Translations.tr('auth_error', 'en')));
      }
    } on Exception catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, UserCredential>> loginWithEmail(
      String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return Left(Exception(Translations.tr('no_account_found', 'en')));
        case 'wrong-password':
          return Left(Exception(Translations.tr('password_incorrect', 'en')));
        case 'invalid-email':
          return Left(Exception(Translations.tr('invalid_email', 'en')));
        case 'invalid-credential':
          return Left(Exception(
              Translations.tr('login_failed', 'en')));
        default:
          return Left(Exception('❗ Firebase error: ${e.code}'));
      }
    }
  }

  @override
  Future<Either<Exception, void>> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Left(Exception(Translations.tr('no_account_found', 'en')));
      } else {
        return Left(Exception(e.message ?? Translations.tr('auth_error', 'en')));
      }
    } catch (e) {
      return Left(Exception(Translations.tr('auth_error', 'en')));
    }
  }

  @override
  Future<Either<Exception, void>> changePassword(
      String oldPassword, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        return Left(Exception(Translations.tr('no_user_logged_in', 'en')));
      }
      final cred = EmailAuthProvider.credential(
          email: user.email!, password: oldPassword);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return Left(Exception(Translations.tr('old_password_incorrect', 'en')));
      }
      return Left(Exception(e.message ?? "${Translations.tr('error', 'en')} changing password"));
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
