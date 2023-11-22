import 'dart:convert';

import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/core/network/app_api.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<bool> checkToken(String token);
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signInWithUsernameAndPassword(String username, String password);
  Future<UserModel> signup({
    required String name,
    required String email,
    required String username,
    required String password,
  });

  Future<Unit> logout(String token);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<bool> checkToken(String token) async {
    final res = await appApiRequest(
      endPoint: '/user/verify',
      method: 'GET',
    );

    final resBody = await res.stream.bytesToString();
    print(resBody);

    if (res.statusCode == 200) {
      return Future.value(true);
    } else if (res.statusCode == 401) {
      return Future.value(false);
    } else {
      throw ServerException(message: 'Token check failed');
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    final res = await appApiRequest(
        auth: false,
        endPoint: '/login',
        method: 'POST',
        data: {
          'login_method': 'email',
          'email': email,
          'password': password,
        });

    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      final userJson = json.decode(resBody)['user'];
      userJson['access_token'] = json.decode(resBody)['access_token'];
      return UserModel.fromJson(userJson);
    } else {
      throw ServerException(message: json.decode(resBody)['message']);
    }
  }

  @override
  Future<UserModel> signInWithUsernameAndPassword(
      String username, String password) async {
    final res = await appApiRequest(
        auth: false,
        endPoint: '/login',
        method: 'POST',
        data: {
          'login_method': 'username',
          'username': username,
          'password': password,
        });

    final resBody = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      final userJson = json.decode(resBody)['user'];
      userJson['access_token'] = json.decode(resBody)['access_token'];
      return UserModel.fromJson(userJson);
    } else {
      throw ServerException(message: json.decode(resBody)['message']);
    }
  }

  @override
  Future<UserModel> signup({
    required String name,
    required String email,
    required String username,
    required String password,
  }) async {
    final res = await appApiRequest(
        auth: false,
        endPoint: '/register',
        method: 'POST',
        data: {
          'name': name,
          'email': email,
          'username': username,
          'password': password,
        });

    final resBody = await res.stream.bytesToString();
    print(resBody);

    if (res.statusCode == 200) {
      final userJson = json.decode(resBody)['user'];
      userJson['access_token'] = json.decode(resBody)['access_token'];
      final user = UserModel.fromJson(userJson);
      return user;
    } else {
      throw ServerException(message: json.decode(resBody)['message']);
    }
  }

  @override
  Future<Unit> logout(String token) async {
    final res = await appApiRequest(
      endPoint: '/user/logout',
      method: 'POST',
    );

    final resBody = await res.stream.bytesToString();
    if (res.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException(message: json.decode(resBody)['message']);
    }
  }


}
