import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/core/errors/failures.dart';
import 'package:chat_app/core/network/network_info.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/home/data/datasources/localDataSource.dart';
import 'package:chat_app/features/home/data/datasources/remoteDataSource.dart';
import 'package:chat_app/features/home/data/models/friends_model.dart';
import 'package:chat_app/features/home/domain/repositories/friend_repo.dart';
import 'package:dartz/dartz.dart';

class FriendRepositoryImpl extends FriendRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  FriendRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  //addFriend
  @override
  Future<Either<Failure, FriendsModel>> addFriend(int friendId) async {
    try {
      final friends = await remoteDataSource.addFriend(friendId);
      return Right(friends);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  //getFriends
  @override
  Future<Either<Failure, List<UserModel>>> getFriends() async {
    if (await networkInfo.isConnected) {
      try {
        final friends = await remoteDataSource.getFriends();
        return Right(friends);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(ServerFailure(message: 'No internet connection'));
    }
  }


}