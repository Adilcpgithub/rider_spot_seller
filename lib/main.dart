import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/auth/auth_serviece.dart';
import 'package:ride_spot/auth_screen/login_screen.dart';
import 'package:ride_spot/blocs/add_product_bloc/bloc/add_product_bloc.dart';
import 'package:ride_spot/blocs/add_product_bloc/bloc/login/bloc/login_bloc.dart';
import 'package:ride_spot/blocs/sign_up/bloc/sign_up_bloc.dart';
import 'package:ride_spot/pages/bottom_navigation_page.dart';
import 'package:ride_spot/utility/app_them.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool status = false;
  @override
  void initState() {
    _checkUserStatus();
    super.initState();
  }

  Future<void> _checkUserStatus() async {
    UserStatus userStatus = UserStatus();
    bool loggedInStatus = await userStatus.isUserLoggedIn();
    setState(() {
      status = loggedInStatus;
      log('when init state called in main screee now you user id is ${UserStatus.userIdFinal}');
      print(status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddProductBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => SignUpBloc()),
      ],
      child: MaterialApp(
        theme: AppThem.theme,
        debugShowCheckedModeBanner: false,
        home: status ? BottomNavigationPage() : const LoginScreen(),
      ),
    );
  }
}
