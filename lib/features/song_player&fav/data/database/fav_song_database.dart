import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify_clone/core/common/errors/exception.dart';
import 'package:spotify_clone/features/home/data/model/song_model.dart';
import 'package:spotify_clone/features/song_player&fav/data/model/current_user_model.dart';

abstract interface class FavSongDatabase {
  Future<void> toggleFavoriteSong(String userId, String songId);
  Future<List<SongModel>> fetchFavSongs(String userId);
  Future<CurrentUserModel> fetchCurrentUser(String userId);
}

class FavSongDatabaseImpl implements FavSongDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<void> toggleFavoriteSong(String userId, String songId) async {
    try {
      final userDoc = firestore.collection('Users').doc(userId);

      // Fetch user's favorite songs
      final userSnapshot = await userDoc.get();
      if (!userSnapshot.exists) throw ServerException('User not found!');

      final userData = userSnapshot.data()!;
      final List<dynamic> favSongs = userData['favSongs'] ?? [];

      if (favSongs.contains(songId)) {
        // If the song is already in favorites, remove it
        await userDoc.update({
          'favSongs': FieldValue.arrayRemove([songId])
        });
      } else {
        // If the song is not in favorites, add it
        await userDoc.update({
          'favSongs': FieldValue.arrayUnion([songId])
        });
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SongModel>> fetchFavSongs(String userId) async {
    try {
      // Getting user's fav song id's
      final userDoc = await firestore.collection('Users').doc(userId).get();
      final userData = userDoc.data()!;
      final favSongs = userData['favSongs'];

      // Fetching favSongDetails
      final res = await firestore
          .collection('Songs')
          .where(FieldPath.documentId, whereIn: favSongs)
          .get();

      final songDetails = res.docs.map(
        (doc) {
          final songData = doc.data();
          return SongModel(
            songId: doc.id,
            title: songData['title'],
            artist: songData['artist'],
            duration: songData['duration'],
            releaseDate: songData['releaseDate'],
            isFav: true,
          );
        },
      ).toList();

      return songDetails;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CurrentUserModel> fetchCurrentUser(String userId) async {
    try {
      final res = await firestore.collection('Users').doc(userId).get();
      print("Fetched user data: ${res.data()}");

      final currentUserData = res.data();

      if (currentUserData != null && currentUserData.isNotEmpty) {
        final currentUserInfo = CurrentUserModel(
          userName: currentUserData['userName'],
          email: currentUserData['email'],
        );

        return currentUserInfo;
      } else {
        throw ServerException("User data not found");
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:spotify_clone/core/common/errors/exception.dart';
// import 'package:spotify_clone/features/home/data/model/song_model.dart';

// abstract interface class FavSongDatabase {
//   Future<List<SongModel>> toggleFavoriteSong(String userId, String songId);
// }

// class FavSongDatabaseImpl implements FavSongDatabase {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   // Toggles the favorite status and returns the updated list of favorite songs
//   @override
//   Future<List<SongModel>> toggleFavoriteSong(
//       String userId, String songId) async {
//     try {
//       final userDoc = firestore.collection('Users').doc(userId);

//       // Fetch user's favorite songs
//       final userSnapshot = await userDoc.get();
//       if (!userSnapshot.exists) throw ServerException('User not found!');

//       final userData = userSnapshot.data()!;
//       final List<dynamic> favSongs = userData['favSongs'] ?? [];

//       if (favSongs.contains(songId)) {
//         // If the song is already in favorites, remove it
//         await userDoc.update({
//           'favSongs': FieldValue.arrayRemove([songId])
//         });
//       } else {
//         // If the song is not in favorites, add it
//         await userDoc.update({
//           'favSongs': FieldValue.arrayUnion([songId])
//         });
//       }

//       // Fetch the updated list of favorite songs
//       final updatedFavSongs = await firestore
//           .collection('Songs')
//           .where(FieldPath.documentId, whereIn: favSongs)
//           .get();

//       // Map the updated list of favorite songs to SongModel instances
//       return updatedFavSongs.docs.map((doc) {
//         final data = doc.data();
//         return SongModel(
//           songId: doc.id,
//           title: data['title'],
//           artist: data['artist'],
//           duration: data['duration'],
//           releaseDate: data['releaseDate'],
//           isFav: true, // Mark as favorite
//         );
//       }).toList();
//     } catch (e) {
//       throw ServerException(e.toString());
//     }
//   }
// }
