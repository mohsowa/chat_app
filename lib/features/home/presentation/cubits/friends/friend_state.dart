part of 'friend_cubit.dart';

abstract class FriendState extends Equatable {
  const FriendState();

  @override
  List<Object> get props => [];
}

class FriendInitial extends FriendState {}

class FriendLoading extends FriendState {}

class FriendLoaded extends FriendState {
  final FriendsModel friends;

  const FriendLoaded({required this.friends});

  @override
  List<Object> get props => [friends];
}

class FriendError extends FriendState {
  final String message;

  const FriendError({required this.message});

  @override
  List<Object> get props => [message];
}

class FriendListLoaded extends FriendState {
  final List<UserModel> friends;

  const FriendListLoaded({required this.friends});

  @override
  List<Object> get props => [friends];

}

class FriendShipLoading extends FriendState {}

class FriendShipLoaded extends FriendState {
  final FriendsModel friends;

  const FriendShipLoaded({required this.friends});

  @override
  List<Object> get props => [friends];
}
