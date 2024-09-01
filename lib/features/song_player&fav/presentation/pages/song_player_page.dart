import 'package:flutter/material.dart';
import 'package:spotify_clone/core/common/widgets/app_bar/app_bar.dart';

class SongPlayerPage extends StatelessWidget {
  const SongPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BasicAppBar(
        title: Text(
          'Now Playing',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
