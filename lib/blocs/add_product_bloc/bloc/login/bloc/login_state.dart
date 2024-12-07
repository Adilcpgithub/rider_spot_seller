part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool isEmailVisible;
  final bool isPickerVisible;
  final String phoneNumber;
  final bool activateValidation;

  const LoginState(
      {this.isEmailVisible = true,
      this.isPickerVisible = false,
      this.phoneNumber = '',
      this.activateValidation = false});
  LoginState copyWith(
      {bool? isEmailVisible,
      bool? isPickerVisible,
      String? phoneNumber,
      bool? activateValidation}) {
    return LoginState(
        isEmailVisible: isEmailVisible ?? this.isEmailVisible,
        isPickerVisible: isPickerVisible ?? this.isPickerVisible,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        activateValidation: activateValidation ?? this.activateValidation);
  }

  @override
  List<Object?> get props =>
      [isEmailVisible, isPickerVisible, phoneNumber, activateValidation];
}
