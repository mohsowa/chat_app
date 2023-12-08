import 'package:chat_app/config/themes/app_style.dart';
import 'package:chat_app/features/home/presentation/cubits/explore/explore_cubit.dart';
import 'package:chat_app/features/home/presentation/cubits/friends/friend_cubit.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/features/auth/auth_di.dart' as auth_di;
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:chat_app/features/home/home_di.dart' as home_di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../cubits/themecubit.dart';
import 'explore.dart';
import 'my_chat.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // For tabs
  final user = auth_di.getUser();

  late AuthCubit authCubit;
  late ExploreCubit exploreCubit;
  late FriendCubit friendCubit;

  final String _baseImageUrl =
      dotenv.env['IMAGE_URL'] ?? 'https://chat.mohsowa.com/api/image';

  @override
  void initState() {
    super.initState();
    home_di.homeInit();
    authCubit = home_di.sl<AuthCubit>();
    friendCubit = home_di.sl<FriendCubit>();
    exploreCubit = home_di.sl<ExploreCubit>(); // Initialize exploreCubit
  }


  // searchController
  final TextEditingController searchController = TextEditingController();

  void _search() {
    String query = searchController.text;

    if (_selectedIndex == 0) {
      friendCubit.searchFriends(query);
    } else {
      if (query.length > 2) {
        exploreCubit.searchExplore(query);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery
              .of(context)
              .size
              .height * 0.28),
          child: AppBar(
            flexibleSpace: SafeArea(
              child: _buildTopSection(),
            ),
            backgroundColor: themeDarkBlue,
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


  BlocBuilder<AuthCubit, AuthState> _buildHeader() {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      builder: (context, state) {
        if (state is AuthLoading) {
          return  Center(
            child: CircularProgressIndicator(
              color: white,
            ),
          );
        } else if (state is AuthLoaded) {
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: Text(
                      state.user.name,
                      style: const TextStyle(color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.light_mode, color: Colors.white),
                    onPressed: () {
                      context.read<ThemeCubit>().toggleTheme(context);
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
        } else {
          return const Center(
            child: Text(
              'Error',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
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
            controller: searchController,
            onChanged: (value) {
              _search();
            },
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
