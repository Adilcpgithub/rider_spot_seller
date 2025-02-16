// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ride_spot/core/shared_prefs.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());
  isLoged() async {
    final status = await AdminStatus.isAdminLoggedIn();
    if (status) {
      emit(const AdminLogInResult(true));
    } else {
      emit(const AdminLogInResult(false));
    }
  }
}
