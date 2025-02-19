// ignore: depend_on_referenced_packages
import 'dart:developer';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  ChatBloc() : super(ChatInitial()) {
    on<FetchChatUserIdsEvent>(fetchChatUserIdsEvent);
    on<FetchUserDetailsEvent>(fetchUserDetailsEvent);
    on<FetchLastMessageTime>(_onFetchLastMessageTime);
  }
  fetchChatUserIdsEvent(
      FetchChatUserIdsEvent event, Emitter<ChatState> emit) async {
    var chatsSnapshot =
        await FirebaseFirestore.instance.collection("chats").get();

// Get all document IDs under "chats"
    List<String> chatIds = chatsSnapshot.docs.map((doc) => doc.id).toList();

    log("Chat document IDs: $chatIds");
    log('FetchChatUserIdsEvent called1');
    emit(ChatLoading());

    try {
      var chatsSnapshot =
          await FirebaseFirestore.instance.collection("chats").get();
      log(chatsSnapshot.docs.toString());

      log('1');
      // Step 1: Fetch all chat document IDs (user IDs who have chatted with admin)
      // QuerySnapshot chatsSnapshot = await _db.collection('chats').get();
      log('2');
      log(chatsSnapshot.docs.toString());
      // Extract user IDs (document IDs) from the chats collection
      List<String> userIds = chatsSnapshot.docs.map((doc) => doc.id).toList();
      log('3');
      log(userIds.toString());
      emit(const ChatUsersLoaded(
          users: [])); // Temporarily emitting an empty list
      log('4');

      // Step 2: Fetch user details for each user ID
      log('5');

      add(FetchUserDetailsEvent(userIds: userIds));
    } catch (e) {
      log(e.toString());
      emit(ChatError(message: e.toString()));
    }
  }

  fetchUserDetailsEvent(
      FetchUserDetailsEvent event, Emitter<ChatState> emit) async {
    log('FetchUserDetailsEvent called');
    emit(ChatLoading());

    try {
      // Step 2: Fetch user details from the users collection
      List<Map<String, dynamic>> users = [];

      for (String userId in event.userIds) {
        DocumentSnapshot userSnapshot =
            await _db.collection('users').doc(userId).get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;

          // Include the document ID as 'id'
          userData['id'] = userSnapshot.id;

          users.add(userData);
        }
      }
      log('koooooi ${users.length}');

      emit(ChatUsersLoaded(users: users)); // Emit user data
    } catch (e) {
      log(e.toString());
      emit(ChatError(message: e.toString()));
    }
  }

  Future<void> _onFetchLastMessageTime(
      FetchLastMessageTime event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    try {
      String chatId = event.userId;

      var snapshot = await _db
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Timestamp lastMessageTime = snapshot.docs.first['timestamp'];
        String formattedTime =
            DateFormat('h:mm a').format(lastMessageTime.toDate());

        emit(LastMessageLoaded(lastMessageTime: formattedTime));
      } else {
        emit(LastMessageLoaded(lastMessageTime: "No messages"));
      }
    } catch (e) {
      emit(ChatError(message: "Error fetching last message time: $e"));
    }
  }
}
