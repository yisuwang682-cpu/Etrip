import 'package:egyptopia/features/auth/data/models/egyptopia_user.dart';

abstract class UserEvent {}

class LoadUser extends UserEvent {
  final String userId;
  LoadUser(this.userId);
}

class UpdateUser extends UserEvent {
  final EgyptopiaUser updatedUser;
  UpdateUser(this.updatedUser);
}

class LogoutUser extends UserEvent {}
