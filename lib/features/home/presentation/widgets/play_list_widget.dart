import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify_clone/core/common/widgets/loader/loader.dart';
import 'package:spotify_clone/core/theme/app_colors.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';
import 'package:spotify_clone/features/home/presentation/bloc/cubit/cubit/song_details_cubit.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/fav_song_details_cubit.dart/fav_song_details_cubit.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/fav_song_details_cubit.dart/fav_song_details_state.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/pages/song_player_page.dart';

/// A widget that displays a vertical list of songs in a playlist format
class PlayListWidget extends StatefulWidget {
  const PlayListWidget({super.key});

  @override
  State<PlayListWidget> createState() => _PlayListWidgetState();
}

class _PlayListWidgetState extends State<PlayListWidget> {
  @override
  Widget build(BuildContext context) {
    // Provide the SongDetailsCubit to this widget's subtree
    return BlocProvider<SongDetailsCubit>(
      create: (_) => GetIt.instance<SongDetailsCubit>()..fetchSongDetails(),
      // Build the UI based on the current state of song details
      child: BlocBuilder<SongDetailsCubit, SongDetailsState>(
        builder: (context, state) {
          // Show loading indicator while fetching song details
          if (state is SongDetailsLoadingState) {
            return const Loader();
          }
          // Display the playlist when song details are successfully loaded
          else if (state is SongDetailsSuccessState) {
            return Column(
              children: [
                // Playlist header with title and "See More" option
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Playlist',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'See More',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xffC6C6C6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // List of songs with vertical scrolling
                ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final song = state.songDetails[index];
                    return SongListItem(song: song);
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemCount: state.songDetails.length,
                ),
              ],
            );
          }
          // Return empty container for other states
          return Container();
        },
      ),
    );
  }
}

/// A widget that represents an individual song item in the playlist
class SongListItem extends StatefulWidget {
  final SongEntity song;

  const SongListItem({
    super.key,
    required this.song,
  });

  @override
  State<SongListItem> createState() => _SongListItemState();
}

class _SongListItemState extends State<SongListItem> {
  // Track favorite status and loading state
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateFavoriteStatus();
  }

  /// Updates the favorite status of the song based on the current state
  void _updateFavoriteStatus() {
    final favState = context.read<FavSongDetailsCubit>().state;
    if (favState is FavSongDetailsSuccess) {
      setState(() {
        _isFavorite = favState.songs.any(
          (favoriteSong) => favoriteSong.songId == widget.song.songId,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for changes in favorite status
    return BlocListener<FavSongDetailsCubit, FavSongDetailsState>(
      listenWhen: (previous, current) {
        // Only listen to state changes that affect this specific song
        if (current is FavSongDetailsSuccess) {
          return current.songs
                  .any((song) => song.songId == widget.song.songId) !=
              _isFavorite;
        }
        return false;
      },
      listener: (context, state) {
        _updateFavoriteStatus();
      },
      // Make the entire song item tappable
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  SongPlayerPage(songEntity: widget.song),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Play button and song info
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffE6E6E6),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Color(0xff555555),
                  ),
                ),
                const SizedBox(width: 10),
                // Song title and artist
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.song.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.song.artist,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Right side: Duration and favorite button
            Row(
              children: [
                Text(widget.song.duration.toString().replaceAll('.', ':')),
                const SizedBox(width: 20),
                // Favorite toggle button with loading state
                IconButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final userId = FirebaseAuth.instance.currentUser?.uid;
                          if (userId != null) {
                            setState(() => _isLoading = true);
                            try {
                              await context
                                  .read<FavSongDetailsCubit>()
                                  .toggleFavoriteSong(
                                      userId, widget.song.songId);
                              // Update local state for immediate UI feedback
                              setState(() {
                                _isFavorite = !_isFavorite;
                              });
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          _isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: _isFavorite ? Colors.red : AppColors.darkGrey,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
