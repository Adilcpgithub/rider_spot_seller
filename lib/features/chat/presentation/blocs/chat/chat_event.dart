part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class FetchChatUserIdsEvent extends ChatEvent {}

class FetchUserDetailsEvent extends ChatEvent {
  final List<String> userIds;

  const FetchUserDetailsEvent({required this.userIds});

  @override
  List<Object> get props => [userIds];
}
