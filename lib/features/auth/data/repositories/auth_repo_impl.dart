import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/core/errors/failures.dart';
import 'package:chat_app/core/network/network_info.dart';
import 'package:chat_app/features/auth/data/datasources/localDataSource.dart';
import 'package:chat_app/features/auth/data/datasources/remoteDataSource.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl implements AuthRepo {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  //getCachedUser
  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      final user = await localDataSource.getCachedUser();

      // check if user token is valid
      final isValid = await remoteDataSource.checkToken(user.access_token!);

      if(isValid){
        return Right(user);
      } else {
        return Left(ServerFailure(message: 'Token is not valid'));
      }
      return Right(user);
    } on EmptyCacheException catch (e) {
      return Left(EmptyCacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  //signInWithEmailAndPassword
  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(String email, String password) async {
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(email, password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }


  @override
  Future<Either<Failure, User>> signInWithUsernameAndPassword(String email, String password) async {
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(email, password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }


}