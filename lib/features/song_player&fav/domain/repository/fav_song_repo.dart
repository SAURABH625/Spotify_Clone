import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';

import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';
import 'package:spotify_clone/features/song_player&fav/domain/entity/current__user.dart';

abstract interface class FavSongRepo {
  Future<Either<Failure, void>> toggleFavoriteSong(
      String userId, String songId);
  Future<Either<Failure, List<SongEntity>>> fetchFavSongs(String userId);
  Future<Either<Failure, CurrentUser>> fetchCurrentUser(String userId);
}
