part of 'splash_cubit.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

final class SplashInitial extends SplashState {}

class AdminLogInResult extends SplashState {
  final bool isLogin;
  const AdminLogInResult(this.isLogin);
  @override
  List<Object> get props => [isLogin];
}
