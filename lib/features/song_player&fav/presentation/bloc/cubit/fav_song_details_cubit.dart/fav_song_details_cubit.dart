import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';
import 'package:spotify_clone/features/song_player&fav/domain/usecases/fav_song_details_usecase.dart';

import 'fav_song_details_state.dart';

class FavSongDetailsCubit extends Cubit<FavSongDetailsState> {
  final FavSongDetailsUsecase favSongDetailsUsecase;

  FavSongDetailsCubit({required this.favSongDetailsUsecase})
      : super(FavSongDetailsLoading());

  Future<void> getFavSongDetails(String songId) async {
    emit(FavSongDetailsLoading());

    final Either<Failure, SongEntity> result = await favSongDetailsUsecase(
        FavSongDetailsUsecaseParams(songId: songId));

    result.fold(
      (failure) => emit(FavSongDetailsFailure(failure.message)),
      (song) => emit(FavSongDetailsSuccess(song)),
    );
  }
}
