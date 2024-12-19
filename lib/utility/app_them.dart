import 'package:flutter/material.dart';
import 'package:ride_spot/utility/colors.dart';

class AppThem {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: CustomColor.primaryColor,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.orange[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.orange,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.orange.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color(0xFFFF8500),
            width: 2.0,
          ),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFFFF8500),
        ),
        hintStyle: TextStyle(
          color: Colors.orange.shade200,
        ),
      ),
    );
  }
}
