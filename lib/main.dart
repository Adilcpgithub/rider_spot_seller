import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/blocs/add_product_bloc/bloc/add_product_bloc.dart';
import 'package:ride_spot/features/auth/presentation/blocs/bloc_login/login_bloc.dart';
import 'package:ride_spot/features/categories/presentation/blocs/add_category/category_bloc.dart';
import 'package:ride_spot/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:ride_spot/features/orders/presentation/screens/updated_order/blocs/admin_order_bloc/admin_order_bloc.dart';
import 'package:ride_spot/features/orders/presentation/screens/updated_order/data/repository/order_repository.dart';
import 'package:ride_spot/features/splash/presentation/blocs/cubit/splash_cubit.dart';
import 'package:ride_spot/features/splash/presentation/screens/splash_screen.dart';
import 'package:ride_spot/features/users/presentation/blocs/user_detail/user_detail_bloc.dart';
import 'package:ride_spot/theme/light_theme.dart';

void main() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCPhgJ67PJp0-rEJPz82wFpAUVavdaV77M",
            authDomain: "nutranest-a6417.firebaseapp.com",
            projectId: "nutranest-a6417",
            storageBucket: "nutranest-a6417.appspot.com",
            messagingSenderId: "544605270040",
            appId: "1:544605270040:web:ebe8021bc66785c5fc536d",
            measurementId: "G-KEXM8FGNPN"));
  } else {
    await Firebase.initializeApp();
  }

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
        BlocProvider(
            create: (context) =>
                AdminOrderBloc(orderRepository: OrderRepository())),
      ],
      child: MaterialApp(
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
