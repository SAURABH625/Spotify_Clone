import 'package:cloud_firestore/cloud_firestore.dart';

class SongModel {
  final String songId;
  final String title;
  final String artist;
  final num duration;
  final Timestamp releaseDate;
  final bool isFav; // Add isFav field

  SongModel({
    required this.songId,
    required this.title,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    this.isFav = false, // Default value set to false
  });

  SongModel copyWith({
    String? songId,
    String? title,
    String? artist,
    num? duration,
    Timestamp? releaseDate,
    bool? isFav, // Add isFav to copyWith method
  }) {
    return SongModel(
      songId: songId ?? this.songId,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      duration: duration ?? this.duration,
      releaseDate: releaseDate ?? this.releaseDate,
      isFav: isFav ?? this.isFav, // Copy isFav value if provided
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'songId': songId,
      'title': title,
      'artist': artist,
      'duration': duration,
      'releaseDate': releaseDate,
      'isFav': isFav, // Add isFav to toJson method
    };
  }

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      songId: json['songId'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      duration: json['duration'] as num,
      releaseDate: json['releaseDate'] as Timestamp,
      isFav: json['isFav'] as bool? ??
          false, // Parse isFav from JSON, default to false if missing
    );
  }
}
