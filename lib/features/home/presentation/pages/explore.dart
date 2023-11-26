import 'package:chat_app/features/home/presentation/cubits/explore/explore_cubit.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/config/themes/app_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/features/home/home_di.dart' as di;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final exploreCubit = di.sl<ExploreCubit>();
  final String _baseImageUrl =
      dotenv.env['IMAGE_URL'] ?? 'https://chat.mohsowa.com/api/image';

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration

    return BlocBuilder<ExploreCubit, ExploreState>(
      bloc: exploreCubit,
      builder: (context, state) {
        if (state is ExploreLoading) {
          return Center(
              child: CircularProgressIndicator(
            color: themeBlue,
            backgroundColor: themePink,
          ));
        } else if (state is ExploreLoaded) {
          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                child: InkWell(
                  child: ListTile(
                    onTap: () {
                      // Handle the tap event, e.g., navigate to user profile or send friend request
                      print('$_baseImageUrl${user.avatar}');
                    },
                    leading: CircleAvatar(
                      backgroundColor: themeLightGrey,
                      radius: 28,
                      child: Image.network(
                        '$_baseImageUrl${user.avatar}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            color: themeDarkBlue,
                            size: 40,
                          );
                        },
                      ),
                    ),
                    title: Text(user.name),
                    subtitle: Text('@${user.username}'),
                    trailing: IconButton(
                      icon: Icon(Icons.person_add),
                      onPressed: () {
                        // Handle the add friend action
                      },
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('No users found'));
        }
      },
    );
  }
}

/*
return Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: InkWell(
            onTap: () {
              // Handle the tap event, e.g., navigate to user profile or send friend request
              print('Tapped on ${user['name']}');
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['imageUrl']),
                radius: 28,
              ),
              title: Text(user['name']),
              subtitle: Text(user['info']),
              trailing: IconButton(
                icon: Icon(Icons.person_add),
                onPressed: () {
                  // Handle the add friend action
                  print('Add ${user['name']} as a friend');
                },
              ),
            ),
          ),
        );
 */
