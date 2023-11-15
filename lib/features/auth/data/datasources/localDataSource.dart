import 'dart:convert';

import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
 // getCachedUser
  Future<UserModel> getCachedUser();
}

class LocalDataSourceImpl implements LocalDataSource {
  // sharedPreferences
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({
    required this.sharedPreferences,
  });

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


}

