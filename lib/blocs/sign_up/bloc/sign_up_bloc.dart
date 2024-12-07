import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState.initial()) {
    on<NameChanged>((event, emit) {
      emit(state.copyWith(name: event.name, isFormValid: _validateForm()));
    });
    on<PhoneChanged>((event, emit) {
      emit(state.copyWith(
          phoneNumber: event.phoneNumber, isFormValid: _validateForm()));
    });
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email, isFormValid: _validateForm()));
    });
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(email: event.password, isFormValid: _validateForm()));
    });
    on<TogglePickerVisibility>((event, emit) {
      emit(state.copyWith(isPickerVisible: !state.isPickerVisible));
    });

    on<ActivateValidation>((event, emit) {
      emit(state.copyWith(activateValidation: true));
    });
    //
    on<SignUpSubmitted>((event, emit) {});
  }

  bool _validateForm() {
    return state.name.isNotEmpty &&
        state.phoneNumber.isNotEmpty &&
        state.email.isNotEmpty &&
        state.password.isNotEmpty;
  }
}
