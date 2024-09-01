import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify_clone/core/common/widgets/loader/loader.dart';
import 'package:spotify_clone/features/home/presentation/bloc/cubit/cubit/song_details_cubit.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/pages/song_player_page.dart';

class SongDetailsCard extends StatelessWidget {
  const SongDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SongDetailsCubit>()..fetchSongDetails(),
      child: BlocBuilder<SongDetailsCubit, SongDetailsState>(
        builder: (context, state) {
          if (state is SongDetailsLoadingState) {
            return const Loader();
          } else if (state is SongDetailsSuccessState) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final songDetails = state.songDetails[index];
                final imageUrl =
                    'https://firebasestorage.googleapis.com/v0/b/spotifyclone-244fd.appspot.com/o/Covers%2F${Uri.encodeComponent(songDetails.artist + ' - ' + songDetails.title)}.jpg?alt=media';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SongPlayerPage(
                            // songEntity: state.songDetails[index],
                            ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print(
                                        'Image.network failed to load: $error'); // Image.network error logging
                                    return Icon(Icons.error);
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  transform:
                                      Matrix4.translationValues(10, 10, 0),
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: Color(0xff959595),
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffE6E6E6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          songDetails.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          songDetails.artist,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                width: 14,
              ),
              itemCount: state.songDetails.length,
            );
          }
          return Container();
        },
      ),
    );
  }
}
