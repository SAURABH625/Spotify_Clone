import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/features/song_player&fav/domain/entity/current__user.dart';
import 'package:spotify_clone/features/song_player&fav/domain/repository/fav_song_repo.dart';

class FetchCurrentUser implements Usecase<CurrentUser, FetchCurrentUserParams> {
  final FavSongRepo favSongRepo;

  FetchCurrentUser({required this.favSongRepo});
  @override
  Future<Either<Failure, CurrentUser>> call(
      FetchCurrentUserParams params) async {
    return await favSongRepo.fetchCurrentUser(params.userId);
  }
}

class FetchCurrentUserParams {
  final String userId;

  FetchCurrentUserParams({required this.userId});
}
