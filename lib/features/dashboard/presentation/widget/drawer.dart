import 'package:flutter/material.dart';
import 'package:ride_spot/core/shared_prefs.dart';
import 'package:ride_spot/features/settings/presentation/widgets/logout_show_dialog.dart';

class AdminDrawer extends StatelessWidget {
  final Function(int) onItemSelected;

  const AdminDrawer({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF4F3EF),
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Admin"),
            accountEmail: Text("admin@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.admin_panel_settings,
                  size: 40, color: Colors.blue),
            ),
          ),
          _buildDrawerItem(context,
              icon: Icons.dashboard, text: "Dashboard", index: 0),
          _buildDrawerItem(context,
              icon: Icons.shopping_cart, text: "Orders", index: 1),
          _buildDrawerItem(context,
              icon: Icons.category, text: "Products", index: 2),
          _buildDrawerItem(context,
              icon: Icons.person, text: "Users", index: 3),
          _buildDrawerItem(context,
              icon: Icons.message, text: "Chat", index: 4),
          _buildDrawerItem(context,
              icon: Icons.settings, text: "Settings", index: 5),
          const Spacer(),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon, required String text, required int index}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text),
      onTap: () {
        onItemSelected(index); // Switch page without rebuilding everything
      },
    );
  }
}
