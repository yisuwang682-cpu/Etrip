import 'package:egyptopia/features/auth/data/egyptopia_api_service.dart';
import 'package:egyptopia/features/auth/data/models/egyptopia_user.dart';
import 'package:egyptopia/features/auth/domain/respotireis/auth_repo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl extends AuthRepo {
  final EgyptopiaApiService _apiService = EgyptopiaApiService();

  @override
  Future<Either<Exception, UserCredential>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return Left(Exception('Google sign-in was cancelled.'));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

       if (user != null) {
        final exists = await _apiService.userExists(user.uid);
        if (!exists) {
          EgyptopiaUser egyptopiaUser = EgyptopiaUser(
            id: user.uid,
            email: user.email!,
            name: user.displayName ?? '',
            country: null,
            dateOfBirth: null,
            gender: null,
            profileImg: user.photoURL,
          );
          try {
            await _apiService.createUser(egyptopiaUser);
          } catch (e) {
            return Left(Exception("API Error: $e"));
          }
        }
      }

      return Right(userCredential);
    } catch (e) {
      return Left(Exception('Error during Google Sign-In: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, UserCredential?>> signUpWithEmail(
    EgyptopiaUser user,
    String signUpPassword,
  ) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: signUpPassword,
      );

      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        EgyptopiaUser newUser = EgyptopiaUser(
          id: firebaseUser.uid,
          name: user.name,
          email: user.email,
          country: user.country,
          dateOfBirth: user.dateOfBirth,
          gender: user.gender,
          profileImg: user.profileImg,
        );
 try {
          await _apiService.createUser(newUser); 
        } catch (e) {
          return Left(Exception("API Error: $e"));
        }

        if (!firebaseUser.emailVerified) {
          await firebaseUser.sendEmailVerification();
          await FirebaseAuth.instance.signOut();
          return const Right(null);
        }
        return Right(userCredential);
      }

      return Left(Exception("Sign up failed, Please try again."));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return Left(Exception(
            '⚠️ There Is An Account Actually Associated With This Email.'));
      } else {
        return Left(Exception(e.message ?? '⚠️ An error happened'));
      }
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, UserCredential>> loginWithEmail(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        await FirebaseAuth.instance.signOut();
        return Left(Exception("Please Verify Your Email Before Logging In."));
      }

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return Left(Exception('❌ No Account Found With This Email.'));
        case 'wrong-password':
          return Left(Exception('❌ The Password Is Incorrect.'));
        case 'invalid-email':
          return Left(Exception('⚠️ The Email Address Is Badly Formatted.'));
        case 'invalid-credential':
          return Left(Exception(
              "❌ This Email Doesn't Exist or The Password Is Incorrect"));
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
        return Left(Exception('⚠️ No Account Found With This Email!'));
      } else {
        return Left(Exception(e.message ?? '⚠️ An Error Occurred!'));
      }
    } catch (e) {
      return Left(Exception('⚠️ An Error Occurred!'));
    }
  }

  @override
Future<Either<Exception, void>> changePassword(String oldPassword, String newPassword) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      return Left(Exception("No user logged in"));
    }
    final cred = EmailAuthProvider.credential(email: user.email!, password: oldPassword);
    await user.reauthenticateWithCredential(cred);

    await user.updatePassword(newPassword);
    return const Right(null);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'wrong-password') {
      return Left(Exception("Old password is incorrect!"));
    }
    return Left(Exception(e.message ?? "Error changing password"));
  } catch (e) {
    return Left(Exception(e.toString()));
  }
}
}
