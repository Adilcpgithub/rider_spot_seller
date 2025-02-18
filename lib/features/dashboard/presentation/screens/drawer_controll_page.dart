import 'package:flutter/material.dart';
import 'package:ride_spot/features/chat/presentation/screens/chat_home_screen.dart';
import 'package:ride_spot/features/dashboard/presentation/screens/dash_board_page.dart';
import 'package:ride_spot/features/dashboard/presentation/widget/drawer.dart';
import 'package:ride_spot/features/orders/presentation/screens/order_home_screen.dart';
import 'package:ride_spot/features/orders/presentation/screens/order_screen.dart';
import 'package:ride_spot/features/settings/presentation/screens/settings_screen.dart';
import 'package:ride_spot/features/users/presentation/screens/user_screen.dart';
import 'package:ride_spot/pages/products_page.dart';
import 'package:ride_spot/theme/custom_colors.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    OrderHomeScreen(),
    const ProductPage(),
    const UserListScreen(),
    const ChatHomeScreen(),
    const SettingScreen(),
  ];
  final List<String> titile = [
    'Dashboard',
    'Orders',
    'Products',
    'Users',
    'Chat',
    'Settings',
  ];

  void _onItemTapped(
    int index,
  ) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: CustomColor.lightpurple,
          title: Text(
            titile[_selectedIndex],
            style: const TextStyle(color: Colors.white),
          )),
      drawer: AdminDrawer(
        onItemSelected: _onItemTapped,
      ), // Pass function to drawer
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
