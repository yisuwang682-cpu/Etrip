import 'package:etrip/features/auth/data/models/egyptopia_user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final EgyptopiaUser user;
  UserLoaded(this.user);
}

class UserError extends UserState {
  final String error;
  UserError(this.error);
}

class UserUnauthenticated extends UserState {}