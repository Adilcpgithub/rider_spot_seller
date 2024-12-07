part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends SignUpEvent {
  final String name;
  const NameChanged(this.name);
}

class PhoneChanged extends SignUpEvent {
  final String phoneNumber;
  const PhoneChanged(this.phoneNumber);
}

class EmailChanged extends SignUpEvent {
  final String email;
  const EmailChanged(this.email);
}

class PasswordChanged extends SignUpEvent {
  final String password;
  const PasswordChanged(this.password);
}

class SignUpSubmitted extends SignUpEvent {}

class ActivateValidation extends SignUpEvent {
  @override
  List<Object> get props => [];
}

class TogglePickerVisibility extends SignUpEvent {
  @override
  List<Object> get props => [];
}
