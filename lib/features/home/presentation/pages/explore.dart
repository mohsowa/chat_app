import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    final List<Map<String, dynamic>> users = [
      {
        'name': 'Naser',
        'info': 'Loves hiking and photography',
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'name': 'Mahmoud',
        'info': 'loves reading and writing',
        'imageUrl': 'https://via.placeholder.com/150',
      },
      // Add more user items here...
    ];

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
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
      },
    );
  }
}
