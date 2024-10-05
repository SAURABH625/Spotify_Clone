import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/core/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/core/common/widgets/app_bar/app_bar.dart';
import 'package:spotify_clone/core/common/widgets/loader/loader.dart';
import 'package:spotify_clone/core/theme/app_colors.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/fav_song_details_cubit.dart/fav_song_details_cubit.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/fav_song_details_cubit.dart/fav_song_details_state.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/pages/song_player_page.dart';

/// A page that displays a user's favorite songs along with their profile information like name, email id etc...
class FavSongsPage extends StatefulWidget {
  final String userId;
  const FavSongsPage({super.key, required this.userId});

  @override
  State<FavSongsPage> createState() => _FavSongsPageState();
}

class _FavSongsPageState extends State<FavSongsPage> {
  @override
  void initState() {
    super.initState();
    final userId = widget.userId;
    // Initialize favorite songs and user details if userId is valid
    if (userId.isNotEmpty) {
      final cubit = BlocProvider.of<FavSongDetailsCubit>(context);
      // Load user's favorite songs
      cubit.loadFavSongs(userId);
      // Fetch user profile details
      cubit.fetchCurrentUserDetails(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom app bar with dynamic background based on app's theme
      appBar: BasicAppBar(
        title: const Text('User Profile'),
        backgroundColor:
            context.isDarkMode ? const Color(0xff2C2B2B) : Colors.white12,
      ),
      body: Column(
        children: [
          // User profile information section
          _profileInfo(context),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'YOUR FAVORITES',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          // Favorite songs list section
          Expanded(
            child: BlocBuilder<FavSongDetailsCubit, FavSongDetailsState>(
              builder: (context, state) {
                // Show loader while fetching favorite songs
                if (state is FavSongDetailsLoading) {
                  return const Loader();
                  // Display list of favorite songs when loaded successfully
                } else if (state is FavSongDetailsSuccess) {
                  final songs = state.songs;
                  return ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      // Construct the image URL for the song cover
                      final imageUrl =
                          'https://firebasestorage.googleapis.com/v0/b/spotifyclone-244fd.appspot.com/o/Covers%2F${Uri.encodeComponent('${song.artist} - ${song.title}')}.jpg?alt=media';

                      // Individual song list item
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SongPlayerPage(songEntity: song),
                              ),
                            );
                          },
                          child: ListTile(
                            // Rounded border with primary color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                              side: const BorderSide(color: AppColors.primary),
                            ),

                            // Song cover image with error and loading handlers
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.fill,
                                height: 50,
                                width: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.music_note);
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Loader();
                                },
                              ),
                            ),

                            // Title of the song
                            title: Text(song.title),

                            // Name of the artist of the song
                            subtitle: Text(song.artist),

                            // Song duration and favorite button section
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Display formatted song duration
                                Text(
                                  state.songs[index].duration
                                      .toString()
                                      .replaceAll('.', ':'),
                                  style: const TextStyle(fontSize: 14),
                                ),

                                // Some space between Song duration and Favorite button
                                const SizedBox(
                                  width: 10,
                                ),

                                // Song's Favorite button to remove it from favorite list
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<FavSongDetailsCubit>()
                                        .toggleFavoriteSong(
                                            widget.userId, song.songId);
                                  },
                                  icon: const Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.red,
                                    size: 26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                  // Display error message if loading fails
                } else if (state is FavSongDetailsFailure) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  // User Profile Info Banner Widget!!!!!!!!!!!!!
  Widget _profileInfo(BuildContext context) {
    return BlocBuilder<FavSongDetailsCubit, FavSongDetailsState>(
      // Only rebuild when user details state changes
      buildWhen: (previous, current) =>
          current is FavUserDetailsLoading ||
          current is FavUserDetailsSuccess ||
          current is FavUserDetailsFailure,
      builder: (context, state) {
        // Show loader while fetching user details
        if (state is FavUserDetailsLoading) {
          return const Loader();
        }
        // Display user profile when details are loaded successfully
        else if (state is FavUserDetailsSuccess) {
          final user = state.currentUser;
          return Container(
            height: MediaQuery.of(context).size.height / 3.2,
            width: double.maxFinite,
            // Container styling with theme-aware background
            decoration: BoxDecoration(
              color:
                  context.isDarkMode ? const Color(0xff2C2B2B) : Colors.black12,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // User avatar placeholder
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.grey,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // User name display
                Text(
                  user.userName.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 12,
                ),
                // User email display
                Text(
                  'Email: ${user.email}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
          // Display error message if loading user details fails
        } else if (state is FavUserDetailsFailure) {
          return Center(child: Text(state.error));
        }
        return const Text('Failed to load user details');
      },
    );
  }
}
