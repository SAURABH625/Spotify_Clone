import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';
import 'package:spotify_clone/features/song_player&fav/domain/repository/fav_song_repo.dart';

class FavSongDetailsUsecase
    implements Usecase<SongEntity, FavSongDetailsUsecaseParams> {
  final FavSongRepo favSongRepo;

  FavSongDetailsUsecase({required this.favSongRepo});
  @override
  Future<Either<Failure, SongEntity>> call(
      FavSongDetailsUsecaseParams params) async {
    return await favSongRepo.favgetFavSongDetailsById(params.songId);
  }
}

class FavSongDetailsUsecaseParams {
  final String songId;

  FavSongDetailsUsecaseParams({required this.songId});
}
