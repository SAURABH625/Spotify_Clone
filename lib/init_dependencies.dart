import 'package:get_it/get_it.dart';
import 'package:spotify_clone/features/auth/data/datasource/auth_datasource.dart';
import 'package:spotify_clone/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:spotify_clone/features/auth/domain/auth_repository/auth_repository.dart';
import 'package:spotify_clone/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:spotify_clone/features/auth/domain/usecases/user_sign_in_usecase.dart';
import 'package:spotify_clone/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:spotify_clone/features/home/data/datasource/song_datasource.dart';
import 'package:spotify_clone/features/home/data/repository/song_repository_impl.dart';
import 'package:spotify_clone/features/home/domain/repository/song_repository.dart';
import 'package:spotify_clone/features/home/domain/usecases/get_song_details.dart';
import 'package:spotify_clone/features/home/presentation/bloc/cubit/cubit/song_details_cubit.dart';
import 'package:spotify_clone/features/song_player&fav/data/database/fav_song_database.dart';
import 'package:spotify_clone/features/song_player&fav/data/repository/fav_song_repo_impl.dart';
import 'package:spotify_clone/features/song_player&fav/domain/repository/fav_song_repo.dart';
import 'package:spotify_clone/features/song_player&fav/domain/usecases/fetch_current_user.dart';
import 'package:spotify_clone/features/song_player&fav/domain/usecases/fetch_fav_songs.dart';
import 'package:spotify_clone/features/song_player&fav/domain/usecases/toggle_fav_song.dart';
import 'package:spotify_clone/features/song_player&fav/presentation/bloc/cubit/fav_song_details_cubit.dart/fav_song_details_cubit.dart';

// Service locator instance
final sl = GetIt.instance;

void initDep() {
  // ***************** Auth Dependencies *****************

  // Register the AuthDatasource implementation
  sl.registerLazySingleton<AuthDatasource>(
    () => AuthDatasourceImpl(),
  );

  // Register the AuthRepository implementation
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authDatasource: sl(),
    ),
  );

  // Register the RegisterUserUsecase and UserSignInUsecase
  sl.registerLazySingleton(
    () => RegisterUserUsecase(
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => UserSignInUsecase(
      authRepository: sl(),
    ),
  );

  // Register the AuthBloc
  sl.registerFactory(
    () => AuthBloc(
      registerUserUsecase: sl(),
      userSignInUsecase: sl(),
    ),
  );

  // ***************** Song Details Dependencies *****************

  // Register the SongDatasource implementation
  sl.registerLazySingleton<SongDatasource>(
    () => SongDatasourceImpl(),
  );

  // Register the SongRepository implementation
  sl.registerLazySingleton<SongRepository>(
    () => SongRepositoryImpl(
      songDatasource: sl(),
    ),
  );

  // Register the GetSongDetails usecase
  sl.registerLazySingleton(
    () => GetSongDetails(
      songRepository: sl(),
    ),
  );

  // Register the SongDetailsCubit
  sl.registerFactory(
    () => SongDetailsCubit(
      getSongDetails: sl(),
    ),
  );

  // ***************** Favorite Song Dependencies *****************

  // Register the FavSongDatabase implementation
  sl.registerLazySingleton<FavSongDatabase>(
    () => FavSongDatabaseImpl(),
  );

  // Register the FavSongRepo implementation
  sl.registerLazySingleton<FavSongRepo>(
    () => FavSongRepoImpl(
      favSongDatabase: sl(),
    ),
  );

  // Register the ToggleFavSong, FetchFavSongs, and FetchCurrentUser usecases
  sl.registerLazySingleton(
    () => ToggleFavSong(
      favSongRepo: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => FetchFavSongs(
      favSongRepo: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => FetchCurrentUser(
      favSongRepo: sl(),
    ),
  );

  // Register the FavSongDetailsCubit
  sl.registerLazySingleton(
    () => FavSongDetailsCubit(
      fetchFavSongs: sl(),
      toggleFavSong: sl(),
      fetchCurrentUser: sl(),
    ),
  );

  // *********** Add more dependencies as your app scales ************
}
