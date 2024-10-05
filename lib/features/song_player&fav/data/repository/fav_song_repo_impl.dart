import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';
import 'package:spotify_clone/features/song_player&fav/data/database/fav_song_database.dart';
import 'package:spotify_clone/features/song_player&fav/domain/repository/fav_song_repo.dart';

class FavSongRepoImpl implements FavSongRepo {
  final FavSongDatabase favSongDatabase;

  FavSongRepoImpl({required this.favSongDatabase});

  @override
  Future<Either<Failure, SongEntity>> favgetFavSongDetailsById(
      String songId) async {
    try {
      // Fetch the song details from the database using songId
      final songModel = await favSongDatabase.getFavSongDetailsById(songId);

      // Convert the SongModel to SongEntity
      final favSongDetails = SongEntity(
        songId: songModel.songId,
        title: songModel.title,
        artist: songModel.artist,
        duration: songModel.duration,
        releaseDate: songModel.releaseDate,
      );

      return right(favSongDetails);
    } catch (e) {
      // Handle the exception, you could log the error or rethrow it
      return left(Failure('Failed to load song: $e'));
    }
  }
}
