import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ride_spot/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:ride_spot/features/chat/presentation/screens/chat_screen.dart';
import 'package:ride_spot/features/chat/presentation/widgets/chat_home_widgets.dart';
import 'package:ride_spot/theme/custom_colors.dart';
import 'package:ride_spot/utility/app_logo.dart';
import 'package:ride_spot/utility/custom_scaffol_message.dart';
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
                              if (user['profileImage'] != null) {
                                ChatHomeWidgets.showProfileDialog(
                                    context, user['profileImage']);
                              } else {
                                showUpdateNotification(
                                    color: CustomColor.lightpurple,
                                    icon: Icons.account_circle,
                                    context: context,
                                    message: "no profile image available");
                              }
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
                            stream: lastMessageTimeStream(
                                user['id']), // Pass the user ID to the stream
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Loading...",
                                    style: TextStyle(color: Colors.grey));
                              } else if (snapshot.hasError) {
                                return const Text("Error",
                                    style: TextStyle(color: Colors.red));
                              } else if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                );
                              }
                              return const Text("No messages",
                                  style: TextStyle(color: Colors.grey));
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

Stream<String> lastMessageTimeStream(String userId) {
  return FirebaseFirestore.instance
      .collection('chats')
      .doc(userId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .limit(1)
      .snapshots()
      .map((snapshot) {
    if (snapshot.docs.isNotEmpty) {
      Timestamp lastMessageTime = snapshot.docs.first['timestamp'];
      return DateFormat('h:mm a').format(lastMessageTime.toDate());
    }
    return 'No messages';
  });
}
