import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/core/common/widgets/app_bar/app_bar.dart';
import 'package:spotify_clone/core/common/widgets/loader/loader.dart';
import 'package:spotify_clone/core/theme/app_colors.dart';
import 'package:spotify_clone/features/home/domain/entity/song_entity.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/fav_song_details_cubit.dart/fav_song_details_cubit.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/fav_song_details_cubit.dart/fav_song_details_state.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/song_player_cubit.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/song_player_state.dart';

class SongPlayerPage extends StatefulWidget {
  final SongEntity songEntity;
  const SongPlayerPage({super.key, required this.songEntity});

  @override
  State<SongPlayerPage> createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  bool _isFavorite = false;
  bool _isLoading = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _updateFavoriteStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateFavoriteStatus();
  }

  void _updateFavoriteStatus() {
    final favState = context.read<FavSongDetailsCubit>().state;
    if (favState is FavSongDetailsSuccess) {
      setState(() {
        _isFavorite = favState.songs.any(
          (favoriteSong) => favoriteSong.songId == widget.songEntity.songId,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text(
          'Now Playing',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        action: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_vert_rounded,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => SongPlayerCubit()
          ..loadSong(
              'https://firebasestorage.googleapis.com/v0/b/spotifyclone-244fd.appspot.com/o/Songs%2F${Uri.encodeComponent('${widget.songEntity.artist} - ${widget.songEntity.title}')}.mp3?alt=media'),
        child: BlocListener<FavSongDetailsCubit, FavSongDetailsState>(
          listenWhen: (previous, current) {
            // Listen to any changes in the FavSongDetailsState
            return current is FavSongDetailsSuccess;
          },
          listener: (context, state) {
            if (state is FavSongDetailsSuccess) {
              _updateFavoriteStatus();
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            child: Column(
              children: [
                _songCover(context),
                const SizedBox(
                  height: 20,
                ),
                _songDetails(context),
                const SizedBox(
                  height: 15,
                ),
                _songPlayer(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget to display the song cover image
  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
              'https://firebasestorage.googleapis.com/v0/b/spotifyclone-244fd.appspot.com/o/Covers%2F${Uri.encodeComponent('${widget.songEntity.artist} - ${widget.songEntity.title}')}.jpg?alt=media'),
        ),
      ),
    );
  }

  // Widget to display the song details
  Widget _songDetails(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.songEntity.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.songEntity.artist,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
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
                          .toggleFavoriteSong(userId, widget.songEntity.songId);
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
                  size: 35,
                ),
        ),
      ],
    );
  }

  // Widget to display the song player controls
  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoading) {
          return const Loader();
        } else if (state is SongPlayerLoaded) {
          final playerCubit = context.read<SongPlayerCubit>();
          return Column(
            children: [
              //Add Slider theme to Update Slider with drag fucntionality
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6),
                  trackShape: const RoundedRectSliderTrackShape(),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: playerCubit.songPosition.inSeconds.toDouble(),
                  min: 0.0,
                  max: playerCubit.songDuration.inSeconds.toDouble(),
                  onChangeStart: (_) {
                    playerCubit.onDragStart();
                  },
                  onChanged: (value) {
                    playerCubit.onDragUpdate(
                      Duration(seconds: value.toInt()),
                    );
                  },
                  onChangeEnd: (value) {
                    playerCubit.onDragEnd();
                  },
                ),
              ),

              const SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formateDuration(
                        playerCubit.songPosition,
                      ),
                    ),
                    Text(
                      formateDuration(
                        playerCubit.songDuration,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              // Play/Pause Button

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 45,
                    height: 45,
                    child: Icon(Icons.skip_previous_rounded),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<SongPlayerCubit>().playOrPauseSong();
                    },
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: Icon(
                        context.read<SongPlayerCubit>().audioPlayer.playing
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 45,
                    height: 45,
                    child: Icon(Icons.skip_next_rounded),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  // Helper function to format the duration
  String formateDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }
}
