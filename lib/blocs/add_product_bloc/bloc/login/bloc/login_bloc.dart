import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<ToggleEmailVisibility>((event, emit) {
      emit(state.copyWith(isEmailVisible: !state.isEmailVisible));
    });
    on<TogglePickerVisibility>((event, emit) {
      emit(state.copyWith(isPickerVisible: !state.isPickerVisible));
    });
    on<UpdatePhoneNumber>((event, emit) {
      emit(state.copyWith(phoneNumber: event.phoneNumber));
    });
    on<ActivateValidation>((event, emit) {
      emit(state.copyWith(activateValidation: true));
    });
  }
}
