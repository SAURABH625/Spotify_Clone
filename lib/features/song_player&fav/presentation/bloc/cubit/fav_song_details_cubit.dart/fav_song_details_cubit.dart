import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/core/common/errors/failure.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';
import 'package:spotify_clone/features/song_player&fav/domain/entity/current__user.dart';
import 'package:spotify_clone/features/song_player&fav/domain/usecases/fetch_current_user.dart';
import 'package:spotify_clone/features/song_player&fav/domain/usecases/fetch_fav_songs.dart';
import 'package:spotify_clone/features/song_player&fav/domain/usecases/toggle_fav_song.dart';
import 'fav_song_details_state.dart';

//Create a cubit for fetching favorite songs and for toggling song's favorite status
class FavSongDetailsCubit extends Cubit<FavSongDetailsState> {
  final FetchFavSongs fetchFavSongs;
  final ToggleFavSong toggleFavSong;
  final FetchCurrentUser fetchCurrentUser;

  FavSongDetailsCubit({
    required this.fetchFavSongs,
    required this.toggleFavSong,
    required this.fetchCurrentUser,
  }) : super(FavSongDetailsLoading());

  // Fetch Favorite Songs
  Future<void> loadFavSongs(String userId) async {
    emit(FavSongDetailsLoading());
    final result = await fetchFavSongs(FetchFavSongsParams(userId: userId));

    result.fold(
      (Failure failure) => emit(FavSongDetailsFailure(failure.message)),
      (List<SongEntity> songs) => emit(FavSongDetailsSuccess(songs)),
    );
  }

  // Toggle Favorite Status for a Song
  Future<void> toggleFavoriteSong(String userId, String songId) async {
    final result = await toggleFavSong(
      ToggleFavSongParams(userId: userId, songId: songId),
    );

    result.fold(
      (Failure failure) {
        // Emit failure state if needed
        emit(FavSongDetailsFailure(failure.message));
      },
      (_) async {
        // Reload favorite songs after toggle, ensuring UI syncs correctly
        await loadFavSongs(userId);
      },
    );
  }

  // Fetch Current User Details
  Future<void> fetchCurrentUserDetails(String userId) async {
    emit(FavUserDetailsLoading()); // Separate loading for user info
    final result = await fetchCurrentUser(
      FetchCurrentUserParams(userId: userId),
    );

    result.fold(
      (Failure failure) => emit(FavUserDetailsFailure(failure.message)),
      (CurrentUser currentUser) {
        emit(FavUserDetailsSuccess(currentUser));
        print('UserInfo : ${currentUser.email}');
      },
    );
  }
}
