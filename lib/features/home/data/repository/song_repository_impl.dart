import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/exception.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/features/home/data/datasource/song_datasource.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';
import 'package:spotify_clone/features/home/domain/repository/song_repository.dart';

class SongRepositoryImpl implements SongRepository {
  final SongDatasource songDatasource;

  SongRepositoryImpl({required this.songDatasource});
  @override
  Future<Either<Failure, List<SongEntity>>> getSongDetails() async {
    try {
      final res = await songDatasource.getSongDetails();

      final List<SongEntity> songDetails = res.map((song) {
        return SongEntity(
          songId: song.songId,
          title: song.title,
          artist: song.artist,
          duration: song.duration,
          releaseDate: song.releaseDate,
        );
      }).toList();

      return right(songDetails);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
