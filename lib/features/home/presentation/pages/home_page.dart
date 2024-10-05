import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify_clone/core/common/assets/app_images.dart';
import 'package:spotify_clone/core/common/assets/app_vectors.dart';
import 'package:spotify_clone/core/common/helpers/is_dark_mode.dart';
import 'package:spotify_clone/core/common/widgets/app_bar/app_bar.dart';
import 'package:spotify_clone/core/theme/app_colors.dart';
import 'package:spotify_clone/features/home/presentation/widgets/play_list_widget.dart';
import 'package:spotify_clone/features/home/presentation/widgets/song_details_card.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/fav_song_details_cubit.dart/fav_song_details_cubit.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/pages/fav_songs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = user?.uid;

    return MultiBlocProvider(
      providers: [
        // Provide the FavSongDetailsCubit
        BlocProvider<FavSongDetailsCubit>(
          create: (_) {
            final cubit = GetIt.instance<FavSongDetailsCubit>();
            // Load favorite songs immediately when HomePage is created
            if (userId != null) {
              cubit.loadFavSongs(userId);
            }
            return cubit;
          },
        ),
      ],
      child: Scaffold(
        // App Bar
        appBar: BasicAppBar(
          hideBackBtn: true,
          // Spotify Logo for app bar
          title: SvgPicture.asset(AppVectors.logoSvg, height: 40, width: 40),
          // User Profile Icon
          action: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<FavSongDetailsCubit>(context),
                    child: FavSongsPage(userId: userId!),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Home page header with background image
              Center(
                child: SizedBox(
                  height: 140,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SvgPicture.asset(AppVectors.homeTopCard),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Image.asset(AppImages.homeArtist),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Tab bar for different sections
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: context.isDarkMode ? Colors.white : Colors.black,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Text('News',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text('Videos',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text('Artists',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text('Podcasts',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
              // Tab bar view for different sections
              SizedBox(
                height: 260,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Song Card Section
                    const SongDetailsCard(),
                    // Song Videos Section
                    Container(
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Data Found!",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Icon(
                            Icons.movie_filter,
                            color: AppColors.grey,
                            size: 60,
                          ),
                        ],
                      ),
                    ),
                    // Artists Section
                    Container(),
                    // Poadcast Section
                    Container(
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Data Found!",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Icon(
                            Icons.movie_filter,
                            color: AppColors.grey,
                            size: 60,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Playlist widget
              const PlayListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
