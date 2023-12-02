import 'package:chat_app/core/errors/failures.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/home/data/models/friends_model.dart';
import 'package:dartz/dartz.dart';

abstract class FriendRepository {
  Future<Either<Failure, FriendsModel>> addFriend(int friendId);
  Future<Either<Failure, List<UserModel>>> getFriends();
}