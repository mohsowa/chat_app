import 'dart:convert';

import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/core/network/app_api.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<bool> checkToken(String token);
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
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

    if(res.statusCode == 200){
      return Future.value(true);
    } else if (res.statusCode == 401){
      return Future.value(false);
    } else {
      throw ServerException(message: 'Token check failed');
    }

  }

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    final res = await appApiRequest(
      auth: false,
      endPoint: '/login',
      method: 'POST',
      data: {
        'login_method': 'email',
        'email': email,
        'password': password,
      }
    );

    final resBody = await res.stream.bytesToString();


    if(res.statusCode == 200){
      final userJson = json.decode(resBody)['user'];
      userJson['access_token'] = json.decode(resBody)['access_token'];
      return UserModel.fromJson(userJson);
    } else {
      throw ServerException(message: json.decode(resBody)['message']);
    }



  }
}