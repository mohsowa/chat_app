import 'package:chat_app/config/themes/app_style.dart';
import 'package:flutter/material.dart';

import '../../../chatting/presentation/chatting.dart';

class MyChats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    final List<Map<String, dynamic>> chats = [
      {
        'name': 'Adhm',
        'lastMessage': 'Hey, how are you?',
        'unreadCount': 2,
        'time': '10:30 AM',
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'name': 'Mohamed',
        'lastMessage': 'Hi there',
        'unreadCount': 0,
        'time': '10:30 AM',
        'imageUrl': 'https://via.placeholder.com/120',
      },
      // Add more chat items here...
      {
        'name': 'Ahmed',
        'lastMessage': 'where are you bro?',
        'unreadCount': 23,
        'time': '09:23 PM',
        'imageUrl': 'https://via.placeholder.com/120',
      },
      {
        'name': 'Group Chat Example',
        'lastMessage': 'Someone: Check this out!',
        'unreadCount': 5,
        'time': '08:15 PM',
        'isGroup': true,
        'groupIconUrl': 'https://via.placeholder.com/150', // URL for group icon
        'memberImages': [ // URLs for member images (if needed)
          'https://via.placeholder.com/120',
          'https://via.placeholder.com/120',
          // Add more member images...
        ],
      },
    ];

    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    chatPartnerName: chat['name'],
                    chatPartnerImageUrl: chat['isGroup'] ?? false ? chat['groupIconUrl'] : chat['imageUrl'],
                    isGroupChat: chat['isGroup'] ?? false, // Ensure this is always a boolean
                  ),
                ),
              );
            },
            child: ListTile(
              leading: _buildChatAvatar(chat),
              title: Text(chat['name']),
              subtitle: Text(chat['lastMessage']),
              trailing: _buildTrailingWidget(chat),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatAvatar(Map<String, dynamic> chat) {
    if (chat['isGroup'] == true) {
      // For group chats, display a group icon or multiple profile pictures
      return CircleAvatar(
        backgroundImage: NetworkImage(chat['groupIconUrl']),
        radius: 28,
      );
    } else {
      // For individual chats, display the user's profile picture
      return CircleAvatar(
        backgroundImage: NetworkImage(chat['imageUrl']),
        radius: 28,
      );
    }
  }

  Widget _buildTrailingWidget(Map<String, dynamic> chat) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (chat['unreadCount'] > 0)
          CircleAvatar(
            radius: 10,
            child: Text(
              chat['unreadCount'].toString(),
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            backgroundColor: theme_green,
          ),
        SizedBox(height: 4),
        Text(
          chat['time'],
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}