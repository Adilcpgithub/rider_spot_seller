part of 'user_detail_bloc.dart';

abstract class UserDetailState extends Equatable {
  const UserDetailState();

  @override
  List<Object> get props => [];
}

class UserDetailLoading extends UserDetailState {}

class UserDetailLoaded extends UserDetailState {
  final List<Map<String, dynamic>> users;

  const UserDetailLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class UserDetailError extends UserDetailState {
  final String message;

  const UserDetailError({required this.message});

  @override
  List<Object> get props => [message];
}
