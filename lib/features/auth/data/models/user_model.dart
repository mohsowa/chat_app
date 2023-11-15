import 'package:chat_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required int id,
    required String name,
    required String email,
    required String username,
    String? avatar,
    String? access_token,
  }) : super(
          id: id,
          name: name,
          email: email,
          username: username,
          avatar: avatar,
          access_token: access_token
  );

  @override
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      avatar: json['avatar'],
      access_token: json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'avatar': avatar,
      'access_token': access_token!,
    };
  }

  @override
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: int.parse(user.id.toString()),
      name: user.name,
      email: user.email,
      username: user.username,
      avatar: user.avatar,
      access_token: user.access_token ?? '',
    );
  }



}
