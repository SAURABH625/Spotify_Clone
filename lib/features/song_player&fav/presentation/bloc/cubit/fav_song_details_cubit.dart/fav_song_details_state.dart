import 'package:equatable/equatable.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';

abstract class FavSongDetailsState extends Equatable {
  const FavSongDetailsState();

  @override
  List<Object?> get props => [];
}

class FavSongDetailsLoading extends FavSongDetailsState {}

class FavSongDetailsSuccess extends FavSongDetailsState {
  final SongEntity song;

  const FavSongDetailsSuccess(this.song);

  @override
  List<Object?> get props => [song];
}

class FavSongDetailsFailure extends FavSongDetailsState {
  final String error;

  const FavSongDetailsFailure(this.error);

  @override
  List<Object?> get props => [error];
}
