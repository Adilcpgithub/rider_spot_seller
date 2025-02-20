import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:ride_spot/features/chat/presentation/repositories/chat_repositorie.dart';
import 'package:ride_spot/features/chat/presentation/screens/chat_screen.dart';
import 'package:ride_spot/features/chat/presentation/widgets/chat_home_widgets.dart';
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

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ChatBloc>().add(FetchChatUserIdsEvent());
                },
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
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
                          leading: GestureDetector(
                            onTap: () {
                              ChatHomeWidgets.showProfileDialog(
                                  context, user['profileImage'] ?? '');
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  Colors.white, // Placeholder background color
                              backgroundImage: user['profileImage'] != null
                                  ? NetworkImage(user['profileImage'])
                                  : null,

                              child: user['profileImage'] == null
                                  ? const Icon(Icons.person_rounded,
                                      size: 33,
                                      color: Colors.black45) // Fallback icon
                                  : null,
                            ),
                          ),
                          title: Text(
                            user["name"] ?? 'Unknown',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(user["email"] ?? 'No email'),
                          trailing: StreamBuilder<String>(
                            stream: ChatRepositorie.lastMessageTimeStream(
                                user['id']),
                            // Pass the user ID to the stream
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Loading...",
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.grey));
                              } else if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                );
                              }
                              return const Text("No messages",
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey));
                            },
                          ),
                        ));
                  },
                ),
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
