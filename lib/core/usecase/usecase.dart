import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';

abstract interface class Usecase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
