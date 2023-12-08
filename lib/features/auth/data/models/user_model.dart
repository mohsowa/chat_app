import 'package:chat_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required int? id,
    required String name,
    required String email,
    required String username,
    String? access_token,
    required String avatar,
  }) : super(
          id: id,
          name: name,
          email: email,
          username: username,
          access_token: access_token,
          avatar: avatar,
        );

  @override
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      access_token: json['access_token'],
      avatar: json['avatar']?? '',
    );
  }

  Map<String, String> toJson() {
    return {
      'id': id.toString(),
      'name': name,
      'email': email,
      'username': username,
      'access_token': access_token!,
      'avatar': avatar,
    };
  }

  @override
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      username: user.username,
      access_token: user.access_token!,
      avatar: user.avatar,
    );
  }



}
