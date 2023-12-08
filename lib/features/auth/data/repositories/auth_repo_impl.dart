import 'dart:convert';
import 'dart:io';
import 'package:chat_app/core/network/app_api.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/core/errors/excptions.dart';
import 'package:chat_app/core/errors/failures.dart';
import 'package:chat_app/core/network/network_info.dart';
import 'package:chat_app/features/auth/data/datasources/localDataSource.dart';
import 'package:chat_app/features/auth/data/datasources/remoteDataSource.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:http_parser/http_parser.dart';

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
      User remote_user = await remoteDataSource.checkToken(user.access_token!);

      UserModel userModel = UserModel(
        id: remote_user.id,
        name: remote_user.name,
        email: remote_user.email,
        username: remote_user.username,
        avatar: remote_user.avatar,
        access_token: user.access_token,
      );


      if (userModel.access_token != null) {
        await localDataSource.cacheUser(userModel);
        return Right(userModel);
      } else {
        return Left(ServerFailure(message: 'Token is not valid'));
      }
    } on EmptyCacheException catch (e) {
      return Left(EmptyCacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      print(e.toString());
      return Left(ServerFailure(message: 'Something went wrong'));
    }

  }

  //signInWithEmailAndPassword
  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final user =
      await remoteDataSource.signInWithEmailAndPassword(email, password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithUsernameAndPassword(
      String username, String password) async {
    try {
      final user = await remoteDataSource.signInWithUsernameAndPassword(
          username, password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signup(
      String name, String email, String username, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signup(
            name: name, email: email, username: username, password: password);

        await localDataSource.cacheUser(user);

        // cache access token
        String? accessToken = user.access_token;
        await localDataSource.cacheToken(accessToken!);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(unit);
    } on EmptyCacheException catch (e) {
      return Left(EmptyCacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserAvatar(File image) async {
    try {
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
        method: 'Post',
        file: multipartFile,
      );

      final resBody = json.decode(await res.stream.bytesToString());
      print(resBody);

      if (res.statusCode != 200) {
        throw ServerException(message: resBody['message']);
      }
      await remoteDataSource.updateUserAvatar(image);
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserProfile(String name, String username,String email) async {
    try {
      await remoteDataSource.updateUserProfile(name, username,email);
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }


}
