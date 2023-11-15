import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String name;
  final String email;
  final String username;
  final String? avatar;
  final String? access_token;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.avatar,
    this.access_token,
  });

  @override
  List<Object?> get props => [id, name, email, username, avatar, access_token];
}