import 'package:chat_app/config/themes/app_style.dart';
import 'package:chat_app/features/home/presentation/cubits/friends/friend_cubit.dart';
import 'package:chat_app/features/home/presentation/pages/chatting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chat_app/features/home/home_di.dart' as home_di;


class MyChats extends StatefulWidget {
  @override

  _MyChatsState createState() => _MyChatsState();

}

class _MyChatsState extends State<MyChats> {

  final friendCubit = home_di.sl<FriendCubit>();

  final String _baseImageUrl = dotenv.env['IMAGE_URL'] ?? 'https://chat.mohsowa.com/api/image';


  @override
  void initState() {
    super.initState();
    friendCubit.getFriends();
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    return BlocBuilder<FriendCubit, FriendState>(
      bloc: friendCubit,
      builder: (context, state) {
        if (state is FriendLoading) {
          return Center(
              child: CircularProgressIndicator(
                color: themeBlue,
                backgroundColor: themePink,
              )
          );
        } else if (state is FriendListLoaded) {
          return ListView.builder(
            itemCount: state.friends.length,
            itemBuilder: (context, index) {
              final user = state.friends[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                child: InkWell(
                  onTap: () {
                    // Open chat screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(friend: user),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: ClipOval(
                      child: CircleAvatar(
                        backgroundColor: themeLightGrey,
                        radius: 28,
                        child: Image.network(
                          '$_baseImageUrl${user.avatar}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person, color: themeDarkBlue, size: 40);
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: themeBlue,
                                backgroundColor: themePink,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('@${user.username}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    )
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is FriendError) {
          return Center(child: Text(state.message));
        } else {
          return const Center();
        }
      },
    );
  }
}