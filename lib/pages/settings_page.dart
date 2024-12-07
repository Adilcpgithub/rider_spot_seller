import 'package:flutter/material.dart';
import 'package:ride_spot/auth/auth_serviece.dart';
import 'package:ride_spot/auth_screen/login_screen.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: TextButton(
          onPressed: () async {
            await authService.signOut();

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                (Route<dynamic> route) => false);
          },
          child: Text('Log out '),
        ),
      ),
    );
  }
}
