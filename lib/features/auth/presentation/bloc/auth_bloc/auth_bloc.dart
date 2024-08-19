import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/features/auth/domain/entity/user_enitity.dart';
import 'package:spotify_clone/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:spotify_clone/features/auth/domain/usecases/user_sign_in_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUserUsecase _registerUserUsecase;
  final UserSignInUsecase _userSignInUsecase;
  AuthBloc({
    required RegisterUserUsecase registerUserUsecase,
    required UserSignInUsecase userSignInUsecase,
  })  : _registerUserUsecase = registerUserUsecase,
        _userSignInUsecase = userSignInUsecase,
        super(AuthInitial()) {
    on<AuthRegisterUserEvent>(_onRegisterUser);
    on<AuthUserSignInEvent>(_onUserSignIn);
  }

  // Register User
  void _onRegisterUser(
      AuthRegisterUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final res = await _registerUserUsecase(
      RegisterUserParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailureState(error: failure.message)),
      (user) => emit(AuthSuccessState(user: user)),
    );
  }

  // User Sign In
  void _onUserSignIn(AuthUserSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final res = await _userSignInUsecase(
      UserSignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailureState(error: failure.message)),
      (user) => emit(AuthSuccessState(user: user)),
    );
  }
}
