import 'package:chat_app/core/errors/failures.dart';
import 'package:chat_app/features/home/data/models/message_model.dart';
import 'package:dartz/dartz.dart';

abstract class MessageRepository {
  Future<Either<Failure, List<MessageModel>>> sendMessage({required int friend_id, required String message, required String type});
  Future<Either<Failure, List<MessageModel>>> getMessages({required int friend_id});
}