part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatUsersLoaded extends ChatState {
  final List<Map<String, dynamic>> users;

  const ChatUsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object> get props => [message];
}

//this state will show last message
class LastMessageLoaded extends ChatState {
  final String lastMessageTime;

  const LastMessageLoaded({required this.lastMessageTime});

  @override
  List<Object> get props => [lastMessageTime];
}
