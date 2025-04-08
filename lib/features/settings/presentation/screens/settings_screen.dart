import 'package:flutter/material.dart';
import 'package:ride_spot/core/shared_prefs.dart';
import 'package:ride_spot/features/settings/presentation/screens/privacy_screen.dart';
import 'package:ride_spot/features/settings/presentation/screens/terms_screen.dart';
import 'package:ride_spot/features/settings/presentation/widgets/logout_show_dialog.dart';
import 'package:ride_spot/utility/navigation.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF674fa3),
                      radius: 25,
                      child: Text(
                        'Ad', // User initials
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      'Adil cp', // User name
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text('john.doe@example.com'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Settings Options
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      CustomNavigation.push(context, PrivacyPolicyPage());
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsTile(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () {
                      CustomNavigation.push(context, TermsAndConditionsPage());
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Logout Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: _buildSettingsTile(
                icon: Icons.logout,
                title: 'Logout',
                textColor: Colors.red,
                onTap: () {
                  AdminStatus.logout();
                  //this function will show dialoge for confirmation of login
                  showModelDeletingRule(context);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void logout(BuildContext context) {
    AdminStatus.logout();
    //this function will show dialoge for confirmation of login
    showModelDeletingRule(context);
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF674fa3),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
