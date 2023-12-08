import 'dart:io';

import 'package:chat_app/core/errors/failures.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure, User>> getCachedUser();
  Future<Either<Failure, User>> signInWithEmailAndPassword(String email, String password);
  Future<Either<Failure, User>> signInWithUsernameAndPassword(String username, String password);
  Future<Either<Failure, User>> signup(String name, String email, String username, String password);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, User>> updateUserAvatar(File image);
  Future<Either<Failure, User>> updateUserProfile(String name, String username, String email);
}