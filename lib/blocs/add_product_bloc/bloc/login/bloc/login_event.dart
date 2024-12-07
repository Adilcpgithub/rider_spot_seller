part of 'login_bloc.dart';

@immutable
sealed class LoginEvent extends Equatable {
  const LoginEvent();
}

class ToggleEmailVisibility extends LoginEvent {
  @override
  List<Object> get props => [];
}

class TogglePickerVisibility extends LoginEvent {
  @override
  List<Object> get props => [];
}

class ActivateValidation extends LoginEvent {
  @override
  List<Object> get props => [];
}

class UpdatePhoneNumber extends LoginEvent {
  final String phoneNumber;
  const UpdatePhoneNumber(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}
