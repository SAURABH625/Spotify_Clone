part of 'song_details_cubit.dart';

@immutable
sealed class SongDetailsState {}

final class SongDetailsInitial extends SongDetailsState {}

final class SongDetailsLoadingState extends SongDetailsState {}

final class SongDetailsSuccessState extends SongDetailsState {
  final List<SongEntity> songDetails;

  SongDetailsSuccessState({required this.songDetails});
}

final class SongDetailsFailureState extends SongDetailsState {
  final String error;

  SongDetailsFailureState({required this.error});
}
