import 'package:chat_app/config/themes/app_style.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/features/auth/auth_di.dart' as di;
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';

import 'explore.dart';
import 'my_chat.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // For tabs
  final user = di.getUser();
  final authCubit = di.sl<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery
            .of(context)
            .size
            .height * 0.27),
        child: AppBar(
          flexibleSpace: SafeArea(
            child: _buildTopSection(),
          ),
          backgroundColor: theme_darkblue,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
      ),
      body: Column(

        children: <Widget>[
          Expanded(
            child: _selectedIndex == 0 ? MyChats() : Explore(),
          ),
        ],
      ),
    );
  }


  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 12),
          _buildSearchAndTabs(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back', // actual username
              style: TextStyle(color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              user.name, // actual username
              style: const TextStyle(color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.light_mode, color: Colors.white),
              onPressed: () {
                // TODO: Implement light/dark mode toggle
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                authCubit.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndTabs() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this line
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          _buildTabs(),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      child: Row(
        children: [
          // My Chats Button
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _selectedIndex == 0
                        ? const Color.fromRGBO(64, 194, 210, 1)
                        : Colors.grey,
                    width: 3,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                child: const Text(
                  'My Chats',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(10, 44, 64, 1),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),

          // Explore Button
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _selectedIndex == 1
                        ? const Color.fromRGBO(64, 194, 210, 1)
                        : Colors.grey,
                    width: 3,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: const Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(10, 44, 64, 1),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
