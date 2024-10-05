import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_clone/core/common/errors/exception.dart';
import 'package:spotify_clone/features/home/data/model/song_model.dart';

abstract interface class FavSongDatabase {
  Future<SongModel> getFavSongDetailsById(String songId);
}

class FavSongDatabaseImpl implements FavSongDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<SongModel> getFavSongDetailsById(String songId) async {
    try {
      // Fetch the song details by songId from Firestore
      final res = await firestore.collection('Songs').doc(songId).get();
      if (res.exists) {
        // Map Firestore document data to SongModel instance
        final data = res.data()!;

        // Manually map the Firestore data to SongModel
        final song = SongModel(
          songId: songId, // Use the provided songId
          title: data['title'], // Fetch title from the Firestore document
          artist: data['artist'], // Fetch artist
          duration: data['duration'], // Fetch duration
          releaseDate: data['releaseDate'],
        );

        return song;
      } else {
        throw Exception('Song not found');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
