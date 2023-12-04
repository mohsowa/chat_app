import 'package:chat_app/features/home/domain/repositories/messages_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final MessageRepository repository;
  MessagesCubit(this.repository) : super(MessagesInitial());
}