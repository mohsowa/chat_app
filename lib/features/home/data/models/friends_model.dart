import 'package:chat_app/features/home/domain/entities/friends.dart';

class FriendsModel extends Friends {
  final int? id;
  final int user_id;
  final int friend_id;

  const FriendsModel({
    required this.id,
    required this.user_id,
    required this.friend_id,
  }) : super(
    id: id,
    user_id: user_id,
    friend_id: friend_id,
  );

  factory FriendsModel.fromJson(Map<String, dynamic> json) {
    return FriendsModel(
      id: json['id'],
      user_id: json['user_id'],
      friend_id: json['friend_id'],
    );
  }

  Map<String, String> toJson() {
    return {
      'id': id.toString(),
      'user_id': user_id.toString(),
      'friend_id': friend_id.toString(),
    };
  }

  FriendsModel copyWith({
    int? id,
    int? user_id,
    int? friend_id,
  }) {
    return FriendsModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      friend_id: friend_id ?? this.friend_id,
    );
  }
}
