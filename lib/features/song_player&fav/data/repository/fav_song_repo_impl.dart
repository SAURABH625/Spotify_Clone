import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/exception.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';
import 'package:spotify_clone/features/song_player&fav/data/database/fav_song_database.dart';
import 'package:spotify_clone/features/song_player&fav/domain/entity/current__user.dart';
import 'package:spotify_clone/features/song_player&fav/domain/repository/fav_song_repo.dart';

class FavSongRepoImpl implements FavSongRepo {
  final FavSongDatabase favSongDatabase;

  FavSongRepoImpl({required this.favSongDatabase});
  @override
  Future<Either<Failure, List<SongEntity>>> fetchFavSongs(String userId) async {
    try {
      final res = await favSongDatabase.fetchFavSongs(userId);

      // Convert the SongModel to SongEntity
      final songDetailsEntity = res.map(
        (songModel) {
          return SongEntity(
            songId: songModel.songId,
            title: songModel.title,
            artist: songModel.artist,
            duration: songModel.duration,
            releaseDate: songModel.releaseDate,
            isFav: songModel.isFav,
          );
        },
      ).toList();
      return right(songDetailsEntity);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavoriteSong(
      String userId, String songId) async {
    try {
      final res = await favSongDatabase.toggleFavoriteSong(userId, songId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CurrentUser>> fetchCurrentUser(String userId) async {
    try {
      final res = await favSongDatabase.fetchCurrentUser(userId);

      final currentUserInfo = CurrentUser(
        userName: res.userName,
        email: res.email,
      );

      return right(currentUserInfo);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
