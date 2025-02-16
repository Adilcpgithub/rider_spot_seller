import 'package:flutter/material.dart';
import 'package:ride_spot/features/dashboard/presentation/page/dash_board_page.dart';
import 'package:ride_spot/features/dashboard/presentation/widget/graph.dart';
import 'package:ride_spot/features/dashboard/presentation/widget/drawer.dart';
import 'package:ride_spot/features/settings/presentation/screens/settings_screen.dart';
import 'package:ride_spot/pages/orders_page.dart';
import 'package:ride_spot/pages/products_page.dart';
import 'package:ride_spot/theme/custom_colors.dart';
import 'package:ride_spot/utility/app_logo.dart';

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
    const OrdersPage(),
    const ProductPage(),
    const UserListScreen(),
    const DashboardPage(),
    const SettingScreen(),
  ];
  final List<String> titile = [
    'Dashboard',
    'StorePage',
    'Products',
    'DashboardPage',
    'DashboardPage',
    'DashboardPage',
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

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  // Dummy user data
  final List<Map<String, dynamic>> users = const [
    {
      "name": "Alice Johnson",
      "username": "@alicej",
      "status": "Online",
      "profile": "https://via.placeholder.com/50",
    },
    {
      "name": "Bob Smith",
      "username": "@bob_smith",
      "status": "Offline",
      "profile": "https://via.placeholder.com/50",
    },
    {
      "name": "Charlie Brown",
      "username": "@charlieb",
      "status": "Online",
      "profile": "https://via.placeholder.com/50",
    },
    {
      "name": "David Lee",
      "username": "@davidl",
      "status": "Away",
      "profile": "https://via.placeholder.com/50",
    },
    {
      "name": "Emma Watson",
      "username": "@emmaw",
      "status": "Online",
      "profile": "https://via.placeholder.com/50",
    },
    {
      "name": "Franklin D.",
      "username": "@frankd",
      "status": "Busy",
      "profile": "https://via.placeholder.com/50",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 2,
          child: ListTile(
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(appLogo())),
            title: Text(
              user["name"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(user["username"]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: user["status"] == "Online"
                      ? Colors.green
                      : user["status"] == "Offline"
                          ? Colors.grey
                          : Colors.orange,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.message, color: Colors.blue),
                  onPressed: () {
                    // Add message action here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Message sent to ${user["name"]}")),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
