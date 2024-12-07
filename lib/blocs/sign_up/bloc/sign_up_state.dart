part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  final String name;
  final String phoneNumber;
  final String email;
  final String password;
  final bool activateValidation;
  final bool isPickerVisible;

  const SignUpState(
      {required this.name,
      required this.phoneNumber,
      required this.email,
      required this.password,
      required this.isPickerVisible,
      required this.activateValidation});

  factory SignUpState.initial() {
    return const SignUpState(
        name: '',
        phoneNumber: '',
        email: '',
        password: '',
        isPickerVisible: false,
        activateValidation: false);
  }

  SignUpState copyWith(
      {String? name,
      String? phoneNumber,
      String? email,
      String? password,
      bool? isFormValid,
      bool? isPickerVisible,
      bool? activateValidation}) {
    return SignUpState(
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        password: password ?? this.password,
        isPickerVisible: isPickerVisible ?? this.isPickerVisible,
        activateValidation: activateValidation ?? this.activateValidation);
  }

  @override
  List<Object> get props =>
      [name, phoneNumber, email, password, isPickerVisible, activateValidation];
}
