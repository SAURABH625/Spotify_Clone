import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/features/auth/domain/auth_repository/auth_repository.dart';
import 'package:spotify_clone/features/auth/domain/entity/user_enitity.dart';

class UserSignInUsecase implements Usecase<UserEntity, UserSignInParams> {
  final AuthRepository authRepository;

  UserSignInUsecase({required this.authRepository});
  @override
  Future<Either<Failure, UserEntity>> call(UserSignInParams params) async {
    return await authRepository.userSignIn(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password,
  });
}
