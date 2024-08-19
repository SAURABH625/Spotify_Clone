import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/exception.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/features/auth/data/datasource/auth_datasource.dart';
import 'package:spotify_clone/features/auth/domain/auth_repository/auth_repository.dart';
import 'package:spotify_clone/features/auth/domain/entity/user_enitity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl({required this.authDatasource});
  @override
  Future<Either<Failure, UserEntity>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await authDatasource.registerUser(
        name: name,
        email: email,
        password: password,
      );

      final userEntity = UserEntity(
        uid: response.uid,
        name: response.name,
        email: response.email,
      );

      return right(userEntity);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> userSignIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await authDatasource.userSignIn(
        email: email,
        password: password,
      );

      final userEntity = UserEntity(
        uid: response.uid,
        name: response.name,
        email: response.email,
      );

      return right(userEntity);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
