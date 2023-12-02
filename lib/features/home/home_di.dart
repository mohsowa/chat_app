import 'package:chat_app/core/network/network_info.dart';
import 'package:chat_app/features/home/data/datasources/localDataSource.dart';
import 'package:chat_app/features/home/data/datasources/remoteDataSource.dart';
import 'package:chat_app/features/home/data/repositories/explore_repo_impl.dart';
import 'package:chat_app/features/home/data/repositories/friend_repo_impl.dart';
import 'package:chat_app/features/home/domain/repositories/explore_repo.dart';
import 'package:chat_app/features/home/domain/repositories/friend_repo.dart';
import 'package:chat_app/features/home/presentation/cubits/explore/explore_cubit.dart';
import 'package:chat_app/features/home/presentation/cubits/friends/friend_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


final sl = GetIt.instance;
bool _isInitialized = false;

Future<void> homeInit() async {

  if (_isInitialized) {
    // Registration has already occurred, so do nothing.
    return;
  }


  print('HomeInit');

  sl.registerLazySingleton(() => ExploreCubit(sl()));
  sl.registerLazySingleton(() => FriendCubit(sl()));


  sl.registerLazySingleton<ExploreRepository>(
      () => ExploreRepositoryImpl(
        localDataSource: sl(),
        remoteDataSource: sl(),
        networkInfo: sl(),
      )
  );

  sl.registerLazySingleton<FriendRepository>(
      () => FriendRepositoryImpl(
        localDataSource: sl(),
        remoteDataSource: sl(),
        networkInfo: sl(),
      )
  );


  sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(
        client: sl(),
      )
  );


  sl.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImpl(
        sharedPreferences: sl(),
      )
  );

  _isInitialized = true;

}

