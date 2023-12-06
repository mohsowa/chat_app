import 'dart:io';

import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/core/errors/failures.dart';
import 'package:chat_app/core/network/network_info.dart';
import 'package:chat_app/features/home/data/datasources/localDataSource.dart';
import 'package:chat_app/features/home/data/datasources/remoteDataSource.dart';
import 'package:chat_app/features/home/data/models/message_model.dart';
import 'package:chat_app/features/home/domain/repositories/messages_repo.dart';
import 'package:dartz/dartz.dart';

class MessageRepositoryImpl extends MessageRepository{
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MessageRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MessageModel>>> sendMessage({required int friend_id, required String message, required String type}) async {
    if (await networkInfo.isConnected) {
      try {
        final msg = await remoteDataSource.sendMessage(friend_id: friend_id, message: message, type: type);
        return Right(msg);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<MessageModel>>> getMessages({required int friend_id}) async {
    if (await networkInfo.isConnected) {
      try {
        final messages = await remoteDataSource.getMessages(friend_id: friend_id);
        return Right(messages);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(ServerFailure(message: 'No internet connection'));
    }


  }

}