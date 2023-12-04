import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/home/data/models/friends_model.dart';
import 'package:chat_app/features/home/domain/repositories/friend_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

part 'friend_state.dart';

class FriendCubit extends Cubit<FriendState> {
  FriendCubit(this.repository) : super(FriendInitial());
  final FriendRepository repository;

  // addFriend
  Future<void> addFriend(int friendId) async {
    emit(FriendLoading());
    final result = await repository.addFriend(friendId);
    result.fold((l) => emit(FriendError(message: l.message)), (friends) {
      emit(FriendLoaded(friends: friends));
    });
  }

  // getFriends
  Future<void> getFriends() async {
    emit(FriendLoading());
    final result = await repository.getFriends();
    result.fold((l) => emit(FriendError(message: l.message)), (friends) {
      emit(FriendListLoaded(friends: friends));
    });
  }

  // getFriendshipStatus
  Future<void> getFriendshipStatus(int friendId) async {
    emit(FriendShipLoading());
    final result = await repository.getFriendshipStatus(friendId);
    result.fold((l) => emit(FriendError(message: l.message)), (friends) {
      emit(FriendShipLoaded(friends: friends));
    });
  }

  // acceptFriend
  Future<void> acceptFriend(int id) async {
    emit(FriendShipLoading());
    final result = await repository.acceptFriend(id);
    result.fold((l) => emit(FriendError(message: l.message)), (friends) {
      emit(FriendShipLoaded(friends: friends));
    });
  }

  // rejectFriend
  Future<void> rejectFriend(int id) async {
    emit(FriendShipLoading());
    final result = await repository.rejectFriend(id);
    result.fold((l) => emit(FriendError(message: l.message)), (friends) {
      emit(FriendShipLoaded(friends: friends));
    });
  }

}