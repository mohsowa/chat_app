import 'package:bloc/bloc.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  final AuthRepo repository;
  late User user;

  AuthCubit(this.repository) : super(AuthInitial());

  // checkCachedUser
  Future<void> checkCachedUser() async {
    emit(AuthLoading());
    final failureOrUser = await repository.getCachedUser();
    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) {
        this.user = user;
        emit(AuthLoaded(user: user));
      }
    );
  }
}