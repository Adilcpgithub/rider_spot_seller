import 'package:flutter/material.dart';
import 'package:ride_spot/utility/app_logo.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  // Dummy user data
  final List<Map<String, dynamic>> users = const [
    {
      "name": "Alice Johnson",
      "username": "@alicej",
      "status": "Online",
      "profile": "https://via.placeholder.com/50",
    },
    {
      "name": "Bob Smith",
      "username": "@bob_smith",
      "status": "Offline",
      "profile": "https://via.placeholder.com/50",
    },
    {
      "name": "Charlie Brown",
      "username": "@charlieb",
      "status": "Online",
      "profile": "https://via.placeholder.com/50",
    },
    {
      "name": "David Lee",
      "username": "@davidl",
      "status": "Away",
      "profile": "https://via.placeholder.com/50",
    },
    {
      "name": "Emma Watson",
      "username": "@emmaw",
      "status": "Online",
      "profile": "https://via.placeholder.com/50",
    },
    {
      "name": "Franklin D.",
      "username": "@frankd",
      "status": "Busy",
      "profile": "https://via.placeholder.com/50",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 2,
          child: ListTile(
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(appLogo())),
            title: Text(
              user["name"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(user["username"]),
          ),
        );
      },
    );
  }
}
