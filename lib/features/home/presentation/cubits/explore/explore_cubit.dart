import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/home/domain/repositories/explore_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit(this.repository) : super(ExploreInitial());
  final ExploreRepository repository;

  // searchExplore
  Future<void> searchExplore(String query) async {
    emit(ExploreLoading());
    final result = await repository.searchExplore(query);
    result.fold((l) => emit(ExploreError(message: l.message)), (users) {
      if (users.isEmpty) {
        emit(ExploreEmpty());
        return;
      }
      emit(ExploreLoaded(users: users));
    });
  }

  
}