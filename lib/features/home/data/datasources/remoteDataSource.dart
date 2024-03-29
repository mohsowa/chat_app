import 'dart:convert';
import 'dart:io';

import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/core/network/app_api.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/home/data/models/friends_model.dart';
import 'package:chat_app/features/home/data/models/message_model.dart';
import 'package:chat_app/features/home/domain/entities/message.dart';
import 'package:http/http.dart' as http;


abstract class RemoteDataSource {
  // searchExplore
  Future<List<UserModel>> searchExplore(String query);
  //addFriend
  Future<FriendsModel> addFriend(int friendId);
  //getFriends
  Future<List<UserModel>> getFriends();
  // getFriendshipStatus
  Future<FriendsModel> getFriendshipStatus(int friendId);
  // acceptFriend
  Future<FriendsModel> acceptFriend(int id);
  // rejectFriend
  Future<FriendsModel> rejectFriend(int id);
  // sendMessage
  Future<List<MessageModel>> sendMessage({required int friend_id, required String message, required String type});
  // getMessages
  Future<List<MessageModel>> getMessages({required int friend_id});
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

  //getFriendshipStatus
  @override
  Future<FriendsModel> getFriendshipStatus(int friendId) async {
    try {
      final res = await appApiRequest(
          auth: true,
          endPoint: '/friend/get/$friendId',
          method: 'GET',
      );
      final resBody = json.decode(await res.stream.bytesToString());
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

  //acceptFriend
  @override
  Future<FriendsModel> acceptFriend(int id) async {
    try {
      final res = await appApiRequest(
          auth: true,
          endPoint: '/friend/accept',
          method: 'POST',
          data: {
            'id': id.toString(),
          }
      );
      final resBody = json.decode(await res.stream.bytesToString());
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

  //rejectFriend
  @override
  Future<FriendsModel> rejectFriend(int id) async {
    try {
      final res = await appApiRequest(
          auth: true,
          endPoint: '/friend/reject',
          method: 'POST',
          data: {
            'id': id.toString(),
          }
      );
      final resBody = json.decode(await res.stream.bytesToString());
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


  //sendMessage
  @override
  Future<List<MessageModel>> sendMessage({required int friend_id, required String message, required String type}) async {
    try {
      final res = await appApiRequest(
          auth: true,
          endPoint: '/message/send',
          method: 'POST',
          data: {
            'friend_id': friend_id.toString(),
            'message': message,
            'type': type,
          }
      );
      final resBody = json.decode(await res.stream.bytesToString());
      print(resBody);
      if (res.statusCode != 200) {
        throw ServerException(message: resBody['message']);
      }
      final messages = resBody['messages'].map<MessageModel>((message) {
        return MessageModel.fromJson(message);
      }).toList();
      return messages;
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  //getMessages
  @override
  Future<List<MessageModel>> getMessages({required int friend_id}) async {
    try {
      final res = await appApiRequest(
          auth: true,
          endPoint: '/message/get/$friend_id',
          method: 'GET',
      );
      final resBody = json.decode(await res.stream.bytesToString());
      if (res.statusCode != 200) {
        throw ServerException(message: resBody['message']);
      }
      final messages = resBody['messages'].map<MessageModel>((message) {
        return MessageModel.fromJson(message);
      }).toList();
      return messages;
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }




}
