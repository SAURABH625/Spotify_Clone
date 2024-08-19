import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/features/auth/domain/entity/user_enitity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> registerUser({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> userSignIn({
    required String email,
    required String password,
  });
}
