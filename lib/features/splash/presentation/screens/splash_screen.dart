import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/features/auth/presentation/screens/login_screen.dart';
import 'package:ride_spot/features/dashboard/presentation/page/drawer_controll_page.dart';
import 'package:ride_spot/features/splash/presentation/blocs/cubit/splash_cubit.dart';
import 'package:ride_spot/utility/app_logo.dart';
import 'package:ride_spot/utility/navigation.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) async {
        await Future.delayed(const Duration(seconds: 3));
        if (state is AdminLogInResult && state.isLogin) {
          if (context.mounted) {
            CustomNavigation.pushAndRemoveUntil(context, const AdminHomePage());

            //BottomNavigationPage()
          }
        } else {
          if (context.mounted) {
            CustomNavigation.pushAndRemoveUntil(context, const LoginScreen());
          }
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInLeft(
                  child: Image.asset(
                appLogo(),
                height: deviceHeight(context) / 3,
              ))
            ],
          ))),
    );
  }
}
