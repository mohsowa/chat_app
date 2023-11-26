import 'package:chat_app/core/errors/failures.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class ExploreRepository {
  Future<Either<Failure, List<UserModel>>> searchExplore(String query);
}