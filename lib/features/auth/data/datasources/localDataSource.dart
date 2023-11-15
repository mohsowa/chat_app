import 'dart:convert';
import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<void> clearCache();
  Future<UserModel> getCachedUser();
  Future<Unit> cacheUser(UserModel user);
}

class LocalDataSourceImpl implements LocalDataSource {
  // sharedPreferences
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<void> clearCache() async {
    await sharedPreferences.clear();
  }

  // getCachedUser
  @override
  Future<UserModel> getCachedUser() async {
    final jsonUser = sharedPreferences.getString('user');
    if(jsonUser != null){
      final user = UserModel.fromJson(json.decode(jsonUser));
      return Future.value(user);
    } else {
      throw EmptyCacheException(message: 'No user cached');
    }
  }

  // cacheUser
  @override
  Future<Unit> cacheUser(UserModel userToCache) {
    final jsonUser = userToCache.toJson();
    sharedPreferences.setString('user', json.encode(jsonUser));
    return Future.value(unit);
  }


}

