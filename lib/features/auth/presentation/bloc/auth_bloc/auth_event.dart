part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthRegisterUserEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthRegisterUserEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class AuthUserSignInEvent extends AuthEvent {
  final String email;
  final String password;

  AuthUserSignInEvent({
    required this.email,
    required this.password,
  });
}
