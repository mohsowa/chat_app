import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String chatPartnerName;
  final String chatPartnerImageUrl;
  final bool isGroupChat;

  ChatPage({
    Key? key,
    required this.chatPartnerName,
    required this.chatPartnerImageUrl,
    this.isGroupChat = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
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
              backgroundImage: NetworkImage(chatPartnerImageUrl),
            ),
            SizedBox(width: 8),
            Text(
              chatPartnerName,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: Implement action for three-dot menu
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            // This is where your chat messages will go
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildMessageInputField(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 22),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.emoji_emotions),
            onPressed: () {
              // TODO: Implement emoji picker
            },
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Send a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // TODO: Implement sending message functionality
            },
          ),
        ],
      ),
    );
  }
}
