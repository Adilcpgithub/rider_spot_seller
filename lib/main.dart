import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/blocs/add_product_bloc/bloc/add_product_bloc.dart';
import 'package:ride_spot/features/auth/presentation/blocs/bloc_login/login_bloc.dart';
import 'package:ride_spot/features/categories/presentation/blocs/add_category/category_bloc.dart';
import 'package:ride_spot/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:ride_spot/features/splash/presentation/blocs/cubit/splash_cubit.dart';
import 'package:ride_spot/features/splash/presentation/screens/splash_screen.dart';
import 'package:ride_spot/features/users/presentation/blocs/user_detail/user_detail_bloc.dart';
import 'package:ride_spot/theme/light_theme.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddProductBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => SplashCubit()..isLoged()),
        BlocProvider(create: (context) => ChatBloc()),
        BlocProvider(create: (context) => UserDetailBloc()),
        BlocProvider(
            create: (context) => CategoryBloc()..add(LoadCategories())),

        //CategoryBloc
      ],
      child: MaterialApp(
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
