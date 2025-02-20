part of 'user_detail_bloc.dart';

abstract class UserDetailEvent extends Equatable {
  const UserDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchUsersEvent extends UserDetailEvent {}

class AddressToggleEvent extends UserDetailEvent {
  final bool haveAddress;
  final bool showAddress;
  const AddressToggleEvent(
      {required this.showAddress, required this.haveAddress});
  @override
  List<Object> get props => [haveAddress, showAddress];
}
