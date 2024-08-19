part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSuccessState extends AuthState {
  final UserEntity user;

  AuthSuccessState({required this.user});
}

final class AuthFailureState extends AuthState {
  final String error;

  AuthFailureState({required this.error});
}
