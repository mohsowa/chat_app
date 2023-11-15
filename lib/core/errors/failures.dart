import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message = 'Sorry, something went wrong. Please try again later.';
  @override
  List<Object?> get props => [message];
}

//ServerFailure
class ServerFailure extends Failure {
  final String message;
  ServerFailure({required this.message});
  @override
  List<Object?> get props => [message];
}

// EmptyCacheFailure
class EmptyCacheFailure extends Failure {
  final String message;
  EmptyCacheFailure({required this.message});
  @override
  List<Object?> get props => [message];
}