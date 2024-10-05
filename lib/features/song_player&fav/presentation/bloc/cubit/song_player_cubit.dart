import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/song_player_state.dart';

/// Cubit (Bloc) responsible for managing the state of the song player
class SongPlayerCubit extends Cubit<SongPlayerState> {
  // Instance of the AudioPlayer for playing songs
  AudioPlayer audioPlayer = AudioPlayer();

  // Current song duration and position
  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;
  // Add a flag to track if user is currently dragging or not
  bool isDragging = false;

  // Initialize the cubit with the loading state
  SongPlayerCubit() : super(SongPlayerLoading()) {
    // Listen to the position stream of the audio player
    audioPlayer.positionStream.listen((position) {
      if (!isDragging) {
        songPosition = position;
        updateSongPlayer();
      }
    });

    // Listen to the duration stream of the audio player
    audioPlayer.durationStream.listen((duration) {
      songDuration = duration ?? Duration.zero;
      updateSongPlayer();
    });

    // Add buffered position stream listener
    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      updateSongPlayer();
    });
  }

  /// Updates the song player state to the loaded stat
  void updateSongPlayer() {
    emit(SongPlayerLoaded());
  }

  /// Loads a song from the provided URL
  Future<void> loadSong(String url) async {
    try {
      // Set the URL of the song in the audio player
      await audioPlayer.setUrl(url);
      // Emit the loaded state
      emit(SongPlayerLoaded());
    } catch (e) {
      // Emit the failure state if an error occurs
      emit(SongPlayerFailure());
    }
  }

  /// Toggles the play/pause state of the song
  void playOrPauseSong() {
    // Check the current state of the audio player
    if (audioPlayer.playing) {
      // If the song is playing, stop the audio player
      audioPlayer.stop();
    } else {
      // If the song is not playing, start the audio player
      audioPlayer.play();
    }
    // Emit the loaded state to update the UI
    emit(SongPlayerLoaded());
  }

  // Add method to handle start of user drag
  void onDragStart() {
    isDragging = true;
    updateSongPlayer();
  }

  // Add method to handle user drag update
  void onDragUpdate(Duration position) {
    songPosition = position;
    updateSongPlayer();
  }

  // Add method to handle end of drag
  Future<void> onDragEnd() async {
    isDragging = false;
    await audioPlayer.seek(songPosition);
    updateSongPlayer();
  }

  @override
  Future<void> close() {
    // Dispose the audio player when the cubit is closed
    audioPlayer.dispose();
    return super.close();
  }
}
