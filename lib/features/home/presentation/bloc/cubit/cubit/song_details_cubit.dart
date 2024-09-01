import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';
import 'package:spotify_clone/features/home/domain/usecases/get_song_details.dart';

part 'song_details_state.dart';

class SongDetailsCubit extends Cubit<SongDetailsState> {
  final GetSongDetails _getSongDetails;
  SongDetailsCubit({
    required GetSongDetails getSongDetails,
  })  : _getSongDetails = getSongDetails,
        super(SongDetailsInitial());

  Future<void> fetchSongDetails() async {
    emit(SongDetailsLoadingState());
    Either<Failure, List<SongEntity>> songDeatils =
        await _getSongDetails(NoParams());

    songDeatils.fold(
      (failure) => emit(SongDetailsFailureState(error: failure.message)),
      (songDetails) => emit(SongDetailsSuccessState(songDetails: songDetails)),
    );
  }
}
