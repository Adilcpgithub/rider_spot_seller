import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ride_spot/core/shared_prefs.dart';
import 'package:ride_spot/theme/custom_colors.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String recieverName;
  const ChatScreen(
      {super.key, required this.receiverId, required this.recieverName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage() async {
    if (_messageController.text.isEmpty) return;

    String senderId = AdminStatus.userId;

    await _db
        .collection("chats")
        .doc(widget.receiverId)
        .collection('messages')
        .add({
      "senderId": senderId,
      "receiverId": widget.receiverId,
      "message": _messageController.text,
      "timestamp": FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recieverName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: CustomColor.lightpurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _db
                  .collection("chats")
                  .doc(widget.receiverId)
                  .collection('messages')
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  log('kooi');
                  log(snapshot.hasError.toString());
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  log('snapshot dont have any data1');
                  return const Center(child: Text('no messagges'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No messages');
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe = message['senderId'] == AdminStatus.userId;
                    Timestamp? timestamp = message['timestamp'];
                    String formattedTime = '';
                    if (timestamp != null) {
                      DateTime messageTime = timestamp.toDate();
                      formattedTime = DateFormat('h:mm a').format(messageTime);
                    }
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[200] : Colors.grey[300],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              message['message'],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.only(
                                right: isMe ? 13 : 0, left: !isMe ? 13 : 0),
                            child: Text(
                              formattedTime, // Show formatted time
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        const InputDecoration(hintText: "Type a message"),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: CustomColor.lightpurple,
                  ),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
