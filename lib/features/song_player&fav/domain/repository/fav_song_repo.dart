import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';

abstract interface class FavSongRepo {
  Future<Either<Failure, SongEntity>> favgetFavSongDetailsById(String songId);
}
