import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/features/song_player&fav/domain/repository/fav_song_repo.dart';

class ToggleFavSong implements Usecase<void, ToggleFavSongParams> {
  final FavSongRepo favSongRepo;

  ToggleFavSong({required this.favSongRepo});
  @override
  Future<Either<Failure, void>> call(ToggleFavSongParams params) async {
    return await favSongRepo.toggleFavoriteSong(params.userId, params.songId);
  }
}

class ToggleFavSongParams {
  final String userId;
  final String songId;

  ToggleFavSongParams({required this.userId, required this.songId});
}
