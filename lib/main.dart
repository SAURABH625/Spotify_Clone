import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_clone/core/theme/app_theme.dart';
import 'package:spotify_clone/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:spotify_clone/features/auth/presentation/bloc/theme_change_cubit/theme_cubit.dart';
import 'package:spotify_clone/features/auth/presentation/pages/splash_page.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/fav_song_details_cubit.dart/fav_song_details_cubit.dart';
import 'package:spotify_clone/firebase_options.dart';
import 'package:spotify_clone/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies using the GetIt service locator
  initDep();

  // Initialize Firebase
  await _firebaseInit();

  // Set up HydratedBloc for state persistence
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide the ThemeCubit, AuthBloc, and FavSongDetailsCubit
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider<AuthBloc>(create: (_) => sl()),
        BlocProvider<FavSongDetailsCubit>(create: (_) => sl())
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            themeMode: mode,
            darkTheme: AppTheme.darkTheme,
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}

Future<void> _firebaseInit() async {
  // Initialize Firebase using the default options for the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
