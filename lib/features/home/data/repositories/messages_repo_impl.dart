import 'package:chat_app/core/network/network_info.dart';
import 'package:chat_app/features/home/data/datasources/localDataSource.dart';
import 'package:chat_app/features/home/data/datasources/remoteDataSource.dart';
import 'package:chat_app/features/home/domain/repositories/messages_repo.dart';

class MessageRepositoryImpl extends MessageRepository{
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MessageRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

}