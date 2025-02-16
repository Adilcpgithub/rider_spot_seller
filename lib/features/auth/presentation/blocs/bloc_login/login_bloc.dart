// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ride_spot/auth/auth_serviece.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthService authService = AuthService();
  LoginBloc() : super(LoginState()) {
    on<LogIn>((event, emit) async {
      emit(LoginLoading());
      await Future.delayed(const Duration(seconds: 2));
      final islogged = await authService.logInUserWithEmailAndPassword(
          email: event.email, password: event.password);
      if (islogged) {
        emit(LoginSuccess());
        return;
      } else {
        emit(LoginFailed());
      }
    });
  }
}
