import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';
import 'package:spotify_clone/features/home/domain/repository/song_repository.dart';

class GetSongDetails implements Usecase<List<SongEntity>, NoParams> {
  final SongRepository songRepository;

  GetSongDetails({required this.songRepository});
  @override
  Future<Either<Failure, List<SongEntity>>> call(NoParams params) async {
    return await songRepository.getSongDetails();
  }
}
