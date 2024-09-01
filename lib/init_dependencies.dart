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

final sl = GetIt.instance;

void initDep() {
  // Auth Dependencies
  // Auth Database
  sl.registerLazySingleton<AuthDatasource>(
    () => AuthDatasourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authDatasource: sl(),
    ),
  );

  // Usecases
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

  // Auth Bloc
  sl.registerFactory(
    () => AuthBloc(
      registerUserUsecase: sl(),
      userSignInUsecase: sl(),
    ),
  );

  // Song Details
  // Datasorce
  sl.registerLazySingleton<SongDatasource>(
    () => SongDatasourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<SongRepository>(
    () => SongRepositoryImpl(
      songDatasource: sl(),
    ),
  );

  // Usecase
  sl.registerLazySingleton(
    () => GetSongDetails(
      songRepository: sl(),
    ),
  );

  // Song Details Cubit
  sl.registerFactory(
    () => SongDetailsCubit(
      getSongDetails: sl(),
    ),
  );
}
