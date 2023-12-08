import 'dart:convert';
import 'dart:io';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:http_parser/http_parser.dart';
import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/core/network/app_api.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<User> checkToken(String token);
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signInWithUsernameAndPassword(String username, String password);
  Future<UserModel> signup({
    required String name,
    required String email,
    required String username,
    required String password,
  });

  Future<Unit> logout();
  Future<UserModel> updateUserAvatar(File image);
  Future<UserModel> updateUserProfile(String name, String username, String email);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<User> checkToken(String token) async {

    final res = await appApiRequest(
      token: token,
      endPoint: '/user/verify',
      method: 'GET',
    );

    final resBody = await res.stream.bytesToString();
    if (res.statusCode == 200) {
      final userJson = json.decode(resBody)['user'];
      return UserModel.fromJson(userJson);
    }else {
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
    if (res.statusCode == 201) {
      final userJson = json.decode(resBody)['user'];
      userJson['access_token'] = json.decode(resBody)['access_token'];
      return UserModel.fromJson(userJson);
    } else {
      throw ServerException(message: json.decode(resBody)['message']);
    }
  }

  @override
  Future<Unit> logout() async {
    final res = await appApiRequest(
      auth: true,
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

  @override
  Future<UserModel> updateUserAvatar(File image) async {

    http.MultipartFile? multipartFile = null;

    if (image != null) {
      multipartFile = http.MultipartFile(
        'photo',
        http.ByteStream(image.openRead()),
        await image.length(),
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
    }


    final res = await appApiRequest(
      auth: true,
      endPoint: '/user/updatePhoto',
      method: 'POST',
      file: multipartFile,
    );

    final resBody = await res.stream.bytesToString();
    if (res.statusCode == 200) {
      final userJson = json.decode(resBody)['user'];
      return UserModel.fromJson(userJson);
    } else {
      throw ServerException(message: json.decode(resBody)['message']);
    }
  }


  @override
  Future<UserModel> updateUserProfile(String name, String username, String email) async {
    final res = await appApiRequest(
      auth: true,
      endPoint: '/user/update',
      method: 'POST',
      data: {
        'name': name,
        'username': username,
        'email': email,
      }
    );

    final resBody = await res.stream.bytesToString();
    if (res.statusCode == 200) {
      final userJson = json.decode(resBody)['user'];
      return UserModel.fromJson(userJson);
    } else {
      throw ServerException(message: json.decode(resBody)['message']);
    }
  }



}
