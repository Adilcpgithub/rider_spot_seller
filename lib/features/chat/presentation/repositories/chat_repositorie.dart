import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatRepositorie {
  static Stream<String> lastMessageTimeStream(String userId) {
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
}
