import 'dart:convert';

import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/core/network/app_api.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/home/data/models/friends_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;


abstract class RemoteDataSource {
  // searchExplore
  Future<List<UserModel>> searchExplore(String query);
  //addFriend
  Future<FriendsModel> addFriend(int friendId);
  //getFriends
  Future<List<UserModel>> getFriends();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  // searchExplore
  @override
  Future<List<UserModel>> searchExplore(String query) async {
    try {
      final res = await appApiRequest(
          auth: true,
          data: {
            'search': query,
          },
          endPoint: '/user/explore_search',
          method: 'POST'
      );
      final resBody = json.decode(await res.stream.bytesToString());
      if (res.statusCode != 200) {
        throw ServerException(message: resBody['message']);
      }
      final users = resBody['users'].map<UserModel>((user) {
        return UserModel.fromJson(user);
      }).toList();
      return users;
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  //addFriend
  @override
  Future<FriendsModel> addFriend(int friendId) async {
    try {
      final res = await appApiRequest(
          auth: true,
          data: {
            'friend_id': friendId.toString(),
          },
          endPoint: '/friend/add',
          method: 'POST'
      );
      final resBody = json.decode(await res.stream.bytesToString());
      print(resBody);
      if (res.statusCode != 200) {
        throw ServerException(message: resBody['message']);
      }
      final friends = FriendsModel.fromJson(resBody['friend']);
      return friends;
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  //getFriends
  @override
  Future<List<UserModel>> getFriends() async {
    try {
      final res = await appApiRequest(
          auth: true,
          endPoint: '/friend/all/get',
          method: 'GET'
      );
      final resBody = json.decode(await res.stream.bytesToString());
      print(resBody);
      if (res.statusCode != 200) {
        throw ServerException(message: resBody['message']);
      }
      final friends = resBody['friends'].map<UserModel>((friend) {
        return UserModel.fromJson(friend);
      }).toList();
      return friends;
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
