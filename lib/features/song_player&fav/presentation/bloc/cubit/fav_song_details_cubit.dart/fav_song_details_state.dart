import 'package:equatable/equatable.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';
import 'package:spotify_clone/features/song_player&fav/domain/entity/current__user.dart';

/// Base class for all states related to favorite song details
abstract class FavSongDetailsState extends Equatable {
  const FavSongDetailsState();

  @override
  List<Object?> get props => [];
}

/// State representing the loading state for favorite song details
class FavSongDetailsLoading extends FavSongDetailsState {}

/// State representing the loading state for the current user's details
class FavUserDetailsLoading extends FavSongDetailsState {}

/// State representing the successful retrieval of favorite song details
class FavSongDetailsSuccess extends FavSongDetailsState {
  final List<SongEntity> songs;

  const FavSongDetailsSuccess(this.songs);

  @override
  List<Object?> get props => [songs];
}

/// State representing the successful retrieval of the current user's details
class FavUserDetailsSuccess extends FavSongDetailsState {
  final CurrentUser currentUser;

  const FavUserDetailsSuccess(this.currentUser);

  @override
  List<Object?> get props => [currentUser];
}

/// State representing a failure in retrieving favorite song details
class FavSongDetailsFailure extends FavSongDetailsState {
  final String error;

  const FavSongDetailsFailure(this.error);

  @override
  List<Object?> get props => [error];
}

/// State representing a failure in retrieving the current user's details
class FavUserDetailsFailure extends FavSongDetailsState {
  final String error;

  const FavUserDetailsFailure(this.error);

  @override
  List<Object?> get props => [error];
}
