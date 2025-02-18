import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:ride_spot/features/chat/presentation/screens/chat_screen.dart';
import 'package:ride_spot/utility/navigation.dart';

class ChatHomeScreen extends StatelessWidget {
  const ChatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(FetchChatUserIdsEvent()),
      child: Scaffold(
        body: SafeArea(child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ChatUsersLoaded) {
              final users = state.users; // Ensure state.users exists

              if (users.isEmpty) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      context.read<ChatBloc>().add(FetchChatUserIdsEvent());
                    },
                    child: const Text('No users have chatted with admin.'),
                  ),
                );
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 2,
                    child: ListTile(
                      onTap: () {
                        if (user['id'] != null) {
                          CustomNavigation.push(
                            context,
                            ChatScreen(
                              receiverId: user["id"] ?? '',
                              recieverName: user['name'] ?? 'Chat',
                            ),
                          );
                        } else {
                          log('user id is null');
                        }
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          user['profileImage'] ?? '',
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, size: 50),
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      title: Text(
                        user["name"] ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(user["email"] ?? 'No email'),
                      trailing: IconButton(
                        icon: const Icon(Icons.message, color: Colors.blue),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text("Message sent to ${user["name"]}")),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
                child: Text("Something went wrong. Please try again."));
          },
        )),
      ),
    );
  }
}
