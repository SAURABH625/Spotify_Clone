import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify_clone/core/common/widgets/loader/loader.dart';
import 'package:spotify_clone/features/home/presentation/bloc/cubit/cubit/song_details_cubit.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/fav_song_details_cubit.dart/fav_song_details_cubit.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/pages/song_player_page.dart';

/// A widget that displays a horizontal scrollable list of song cards
/// Each card shows the song's cover image, title, and artist name
class SongDetailsCard extends StatelessWidget {
  const SongDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the SongDetailsCubit to this widget's subtree
    return BlocProvider<SongDetailsCubit>(
      create: (context) => GetIt.I<SongDetailsCubit>()..fetchSongDetails(),
      // Build the UI based on the current state of song details cubit
      child: BlocBuilder<SongDetailsCubit, SongDetailsState>(
        builder: (context, state) {
          // Show loading indicator while fetching song details
          if (state is SongDetailsLoadingState) {
            return const Loader();
            // Display the song cards when details are successfully loaded
          } else if (state is SongDetailsSuccessState) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final songDetails = state.songDetails[index];
                // Construct the image URL for the song cover
                final imageUrl =
                    'https://firebasestorage.googleapis.com/v0/b/spotifyclone-244fd.appspot.com/o/Covers%2F${Uri.encodeComponent('${songDetails.artist} - ${songDetails.title}')}.jpg?alt=media';

                // Make each card tappable to navigate to the song player page
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<FavSongDetailsCubit>(context),
                          child: SongPlayerPage(
                            songEntity: state.songDetails[index],
                          ),
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Song cover image with play button overlay
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Song cover image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print(
                                        'Image.network failed to load: $error'); // Image.network error logging
                                    return const Icon(Icons.error);
                                  },
                                ),
                              ),
                              // Play button overlay
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  transform:
                                      Matrix4.translationValues(10, 10, 0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffE6E6E6),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Color(0xff959595),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Song title
                        Text(
                          songDetails.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // Atrist name
                        Text(
                          songDetails.artist,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              // Spacing between the cards
              separatorBuilder: (context, index) => const SizedBox(
                width: 14,
              ),
              itemCount: state.songDetails.length,
            );
          }
          // Return empty container for other states
          return Container();
        },
      ),
    );
  }
}
