import 'package:flutter/material.dart';
import 'package:ride_spot/utility/colors.dart';

class AppThem {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: CustomColor.primaryColor,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.blue[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: CustomColor.primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.blue.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: CustomColor.primaryColor,
            width: 2.0,
          ),
        ),
        labelStyle: const TextStyle(
          color: CustomColor.primaryColor,
        ),
        hintStyle: TextStyle(
          color: Colors.blue.shade200,
        ),
      ),
    );
  }
}
