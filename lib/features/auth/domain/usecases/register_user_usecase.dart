import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/features/auth/domain/auth_repository/auth_repository.dart';
import 'package:spotify_clone/features/auth/domain/entity/user_enitity.dart';

class RegisterUserUsecase implements Usecase<UserEntity, RegisterUserParams> {
  final AuthRepository authRepository;

  RegisterUserUsecase({required this.authRepository});
  @override
  Future<Either<Failure, UserEntity>> call(RegisterUserParams params) async {
    return await authRepository.registerUser(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterUserParams {
  final String name;
  final String email;
  final String password;

  RegisterUserParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
