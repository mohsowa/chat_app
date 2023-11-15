import 'package:chat_app/core/network/network_info.dart';
import 'package:chat_app/features/auth/data/datasources/localDataSource.dart';
import 'package:chat_app/features/auth/data/datasources/remoteDataSource.dart';
import 'package:chat_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


final sl = GetIt.instance;
//bool _isInit = false;

Future<void> AuthInit() async {

  //if (_isInit) return;

  print('AuthInit');

  sl.registerLazySingleton(
    () => AuthCubit(sl())
  );

  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
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

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl()
  );


  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());


  //_isInit = true;






}

User getUser() {
  return sl.get<AuthCubit>().user;
}