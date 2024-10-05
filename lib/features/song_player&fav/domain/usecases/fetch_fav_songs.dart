import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';
import 'package:spotify_clone/features/song_player&fav/domain/repository/fav_song_repo.dart';

// Fetch Fav Songs Usecase
class FetchFavSongs implements Usecase<List<SongEntity>, FetchFavSongsParams> {
  final FavSongRepo favSongRepo;

  FetchFavSongs({required this.favSongRepo});
  @override
  Future<Either<Failure, List<SongEntity>>> call(
      FetchFavSongsParams params) async {
    return await favSongRepo.fetchFavSongs(params.userId);
  }
}

class FetchFavSongsParams {
  final String userId;

  FetchFavSongsParams({required this.userId});
}
