import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/features/auth/presentation/screens/login_screen.dart';
import 'package:ride_spot/features/dashboard/presentation/screens/drawer_controll_page.dart';
import 'package:ride_spot/features/splash/presentation/blocs/cubit/splash_cubit.dart';
import 'package:ride_spot/utility/app_logo.dart';
import 'package:ride_spot/utility/navigation.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) async {
        await Future.delayed(const Duration(milliseconds: 1500));
        if (state is AdminLogInResult && state.isLogin) {
          if (context.mounted) {
            CustomNavigation.pushAndRemoveUntil(context, const AdminHomePage());
          }
        } else {
          if (context.mounted) {
            CustomNavigation.pushAndRemoveUntil(context, const LoginScreen());
          }
        }
      },
      child: Stack(children: [
        Scaffold(
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
        Positioned(
            bottom: deviceHeight(context) / 2 - 90,
            left: deviceWidth(context) / 2 - 100,
            child: FadeInUp(
              delay: const Duration(seconds: 1),
              child: const Text(
                'Rider Spot Admin',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decorationThickness: 0),
              ),
            ))
      ]),
    );
  }
}
