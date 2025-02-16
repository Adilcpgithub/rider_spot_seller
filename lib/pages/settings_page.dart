import 'package:flutter/material.dart';
import 'package:ride_spot/core/shared_prefs.dart';
import 'package:ride_spot/features/auth/presentation/screens/login_screen.dart';
import 'package:ride_spot/utility/navigation.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: TextButton(
          onPressed: () async {
            //! compete here
            await AdminStatus.logout();
            if (context.mounted) {
              CustomNavigation.pushAndRemoveUntil(context, const LoginScreen());
            }
          },
          child: const Text('Log out '),
        ),
      ),
    );
  }
}
