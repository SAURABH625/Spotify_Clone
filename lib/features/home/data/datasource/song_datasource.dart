import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_clone/core/common/errors/exception.dart';
import 'package:spotify_clone/features/home/data/model/song_model.dart';

abstract interface class SongDatasource {
  Future<List<SongModel>> getSongDetails();
}

class SongDatasourceImpl implements SongDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<SongModel>> getSongDetails() async {
    try {
      // Fetch the Songs collection, ordered by releaseDate
      final res = await firestore
          .collection('Songs')
          .orderBy('releaseDate', descending: true)
          .get();

      // Map the documents to SongModel instances
      final songs = res.docs.map((doc) {
        return SongModel(
          songId: doc.id, // Used the document ID as the songId
          title: doc.data()['title'] ?? '',
          artist: doc.data()['artist'] ?? '',
          duration: doc.data()['duration'] ?? 0,
          releaseDate: doc.data()['releaseDate'] ?? '',
        );
      }).toList();

      return songs; // Return the list of songs
    } catch (e) {
      // Handle any errors that occur during the Firestore operation
      throw ServerException(e.toString());
    }
  }
}
