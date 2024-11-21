import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/core/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/core/common/widgets/app_bar/app_bar.dart';
import 'package:spotify_clone/core/common/widgets/loader/loader.dart';
import 'package:spotify_clone/core/theme/app_colors.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/fav_song_details_cubit.dart/fav_song_details_cubit.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/fav_song_details_cubit.dart/fav_song_details_state.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/pages/song_player_page.dart';

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
    if (userId.isNotEmpty) {
      final cubit = BlocProvider.of<FavSongDetailsCubit>(context);
      cubit.loadFavSongs(userId);
      cubit.fetchCurrentUserDetails(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('User Profile'),
        backgroundColor:
            context.isDarkMode ? const Color(0xff2C2B2B) : Colors.white12,
      ),
      body: Stack(
        children: [
          // Song List in background
          Positioned.fill(
            child: BlocBuilder<FavSongDetailsCubit, FavSongDetailsState>(
              builder: (context, state) {
                if (state is FavSongDetailsLoading) {
                  return const Loader();
                } else if (state is FavSongDetailsSuccess) {
                  final songs = state.songs;
                  return Container(
                    decoration: BoxDecoration(
                      color: context.isDarkMode
                          ? const Color(0xff2C2B2B).withOpacity(0.5)
                          : Colors.white.withOpacity(0.5),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2.5,
                        bottom: 20,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        final imageUrl =
                            'https://firebasestorage.googleapis.com/v0/b/spotifyclone-244fd.appspot.com/o/Covers%2F${Uri.encodeComponent('${song.artist} - ${song.title}')}.jpg?alt=media';

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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                                side:
                                    const BorderSide(color: AppColors.primary),
                              ),
                              leading: SizedBox(
                                height: 50,
                                width: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
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
                              ),
                              title: Text(song.title),
                              subtitle: Text(song.artist),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    state.songs[index].duration
                                        .toString()
                                        .replaceAll('.', ':'),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 10),
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
                    ),
                  );
                } else if (state is FavSongDetailsFailure) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return Container();
              },
            ),
          ),
          // Fixed header overlay
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  children: [
                    _profileInfo(context),
                    const SizedBox(height: 20),
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      child: const Text(
                        'YOUR FAVORITES',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              // Add a small gradient overlay for smooth transition
              Container(
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor,
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    // Keep the existing _profileInfo implementation
    return BlocBuilder<FavSongDetailsCubit, FavSongDetailsState>(
      buildWhen: (previous, current) =>
          current is FavUserDetailsLoading ||
          current is FavUserDetailsSuccess ||
          current is FavUserDetailsFailure,
      builder: (context, state) {
        if (state is FavUserDetailsLoading) {
          return const Loader();
        } else if (state is FavUserDetailsSuccess) {
          final user = state.currentUser;
          return Container(
            height: MediaQuery.of(context).size.height / 3.2,
            width: double.maxFinite,
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
                const SizedBox(height: 20),
                Text(
                  user.userName.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Text(
                  'Email: ${user.email}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        } else if (state is FavUserDetailsFailure) {
          return Center(child: Text(state.error));
        }
        return const Text('Failed to load user details');
      },
    );
  }
}
