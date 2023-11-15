import 'package:chat_app/core/errors/failures.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  //clear Auth State
  Future<Either<Failure, User>> getCachedUser();
  Future<Either<Failure, User>> signInWithEmailAndPassword(String email, String password);
  Future<Either<Failure, User>> signInWithUsernameAndPassword(String email, String password);

}