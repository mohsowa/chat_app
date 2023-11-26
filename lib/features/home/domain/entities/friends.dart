import 'package:equatable/equatable.dart';

class Friends extends Equatable {
  final int? id;
  final int user_id;
  final int friend_id;

  const Friends({
    required this.id,
    required this.user_id,
    required this.friend_id,
  });

  @override
  List<Object?> get props => [id, user_id, friend_id];
}