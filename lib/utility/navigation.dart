import 'package:flutter/material.dart';

class CustomNavigation {
  static Future navigationPush(
    BuildContext context,
    Widget myClass, {
    Curve curve = Curves.easeInOut, // Optional curve parameter
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => myClass,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return FadeTransition(
            opacity: curvedAnimation,
            child: child,
          );
        },
      ),
    );
  }

  static Future navigationPushReplacement(
    BuildContext context,
    Widget myClass, {
    Curve curve = Curves.easeInOut, // Optional curve parameter
  }) {
    {
      return Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => myClass,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // For example, a fade transition
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }
}
