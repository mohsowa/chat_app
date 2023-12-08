import 'package:chat_app/config/themes/app_style.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:chat_app/features/home/data/models/message_model.dart';
import 'package:chat_app/features/home/presentation/cubits/friends/friend_cubit.dart';
import 'package:chat_app/features/home/presentation/cubits/messages/messages_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chat_app/features/home/home_di.dart' as home_di;
import 'package:chat_app/features/auth/auth_di.dart' as auth_di;
import 'dart:async';

class ChatPage extends StatefulWidget {
  final User friend;

  const ChatPage({
    Key? key,
    required this.friend,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final String _baseImageUrl =
      dotenv.env['IMAGE_URL'] ?? 'https://chat.mohsowa.com/api/image';
  final friendCubit = home_di.sl<FriendCubit>();
  late MessagesCubit messagesCubit;
  final user = auth_di.getUser();

  Timer? timer;

  @override
  void initState() {
    super.initState();
    messagesCubit = home_di.sl<MessagesCubit>();
    friendCubit.getFriendshipStatus(widget.friend.id!);

    messagesCubit.getMessages(friend_id: widget.friend.id!);

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      messagesCubit.getMessages(friend_id: widget.friend.id!);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void acceptFriendRequest(id) {
    friendCubit.acceptFriend(id);
  }

  void rejectFriendRequest(id) {
    friendCubit.rejectFriend(id);
  }

  // call messagesCubit.getMessages every 1 second


  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(10, 44, 64, 1), // Dark blue
                Color.fromRGBO(64, 194, 210, 1), // Light blue
              ],
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: themeLightGrey,
              radius: 22,
              child: Image.network('$_baseImageUrl${widget.friend.avatar}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.person,
                  color: themeDarkBlue,
                  size: 30,
                );
              }, loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    color: themeBlue,
                    backgroundColor: themePink,
                  ),
                );
              }),
            ),
            const SizedBox(width: 8),
            Text(
              widget.friend.name,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            friendCubit.getFriends();
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: Implement action for three-dot menu
            },
          ),
        ],
      ),
      body: _buildFriendshipStatus(),
    );
  }

  BlocBuilder<FriendCubit, FriendState> _buildFriendshipStatus() {
    return BlocBuilder<FriendCubit, FriendState>(
      bloc: friendCubit,
      builder: (context, state) {
        if (state is FriendShipLoading) {
          return  Center(child: CircularProgressIndicator(
            color: themeBlue,
            backgroundColor: themePink,
          ));
        } else if (state is FriendShipLoaded) {
          // user is send friend request and friend is not accepted yet
          if (user.id == state.friends.user_id &&
              state.friends.status == 'pending') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add,
                    size: 60,
                    color: themeDarkBlue.withOpacity(0.7),
                  ),
                  Text(
                    'Friend request has been sent',
                    style: TextStyle(color: themeDarkBlue.withOpacity(0.7)),
                  ),
                ],
              ),
            );

            // user is not accepted friend request yet
          } else if (user.id == state.friends.friend_id &&
              state.friends.status == 'pending') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add,
                    size: 60,
                    color: themeDarkBlue.withOpacity(0.7),
                  ),
                  Text(
                    'Friend request pending',
                    style: TextStyle(color: themeDarkBlue.withOpacity(0.7)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: themeBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => acceptFriendRequest(state.friends.id),
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Accept',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: themePink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => rejectFriendRequest(state.friends.id),
                        icon: const Icon(
                          Icons.person_add_disabled,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Reject',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );

            // user is accepted friend request
          } else if (state.friends.status == 'rejected') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add_disabled,
                    size: 60,
                    color: themeDarkBlue.withOpacity(0.7),
                  ),
                  Text(
                    'Friend request rejected',
                    style: TextStyle(color: themeDarkBlue.withOpacity(0.7)),
                  ),
                ],
              ),
            );

            // user is accepted friend request
          } else {
            return _buildMessages();
          }
        } else {
          return const Center(
            child: Text('Error loading chat'),
          );
        }
      },
    );
  }

  List<MessageModel> messages = [];
  BlocBuilder<MessagesCubit, MessagesState> _buildMessages() {
    return BlocBuilder<MessagesCubit, MessagesState>(
      bloc: messagesCubit,
      builder: (context, state) {
        print(state);
        if (state is MessagesLoadedList) {
          messages = state.messages;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.messages.length,
                  reverse: true,
                  scrollDirection: Axis.vertical,
                  semanticChildCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final msg = state.messages[index];
                    if(msg.sender_id == user.id) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(150, 10, 0, 10),
                          alignment: Alignment.centerRight,
                          width: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
                            color: themeDarkBlue.withOpacity(0.8),
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: Text(
                            msg.message!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 150, 10),
                          alignment: Alignment.centerLeft,
                          width: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
                            color: themeLightGrey.withOpacity(0.8),
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: Text(
                            msg.message!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              _buildMessageInputField(),
            ],
          );
        } else {
         return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  reverse: true,
                  scrollDirection: Axis.vertical,
                  semanticChildCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    if(msg.sender_id == user.id) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(150, 10, 0, 10),
                          alignment: Alignment.centerRight,
                          width: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
                            color: themeDarkBlue.withOpacity(0.8),
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: Text(
                            msg.message!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 150, 10),
                          alignment: Alignment.centerLeft,
                          width: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
                            color: themeLightGrey.withOpacity(0.8),
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: Text(
                            msg.message!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              _buildMessageInputField(),
            ],
          );
        }
      },
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              onChanged: (value) {
                _messageController.text = value;
              },
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Send a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                // if text more than 255 characters send error
                if (_messageController.text.length > 254) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message cannot be more than 255 characters'),
                    ),
                  );
                }else{
                  messagesCubit.sendMessage(
                    friend_id: widget.friend.id!,
                    message: _messageController.text,
                    type: 'text',
                  );
                }
              }
              _messageController.text = '';
            },
          ),
        ],
      ),
    );
  }
}
