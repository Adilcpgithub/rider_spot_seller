part of 'login_bloc.dart';

@immutable
sealed class LoginEvent extends Equatable {
  const LoginEvent();
}

class LogIn extends LoginEvent {
  final String email;
  final String password;
  @override
  List<Object> get props => [email, password];
  const LogIn({required this.email, required this.password});
}
