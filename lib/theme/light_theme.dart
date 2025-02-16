import 'package:flutter/material.dart';
import 'package:ride_spot/theme/custom_colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: CustomColor.lightpurple, // Deep Slate Grayc
  scaffoldBackgroundColor: const Color(0xFFF4F3EF), // Soft Beige White
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 1,
    iconTheme: IconThemeData(color: Colors.white), // Slate Gray Icons
    titleTextStyle: TextStyle(
        color: Color(0xFF5A5D6E), fontSize: 20, fontWeight: FontWeight.w600),
  ),
  cardColor: Colors.white,
  dividerColor: const Color(0xFFD1D0C5), // Muted Stone Gray Borders
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF5A5D6E), // Deep Slate Gray Buttons
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF5A5D6E)), // Deep Slate Gray
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFB0A695)), // Warm Taupe
  ),
  iconTheme: const IconThemeData(color: Color(0xFF5A5D6E)), // Slate Gray icons
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFD1D0C5)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFD1D0C5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
          color: Color(0xFF5A5D6E)), // Deep Slate Gray Focus Color
    ),
  ),
);
// Color Name	Hex Code	Usage
// Primary	#5A5D6E (Deep Slate Gray)	Buttons, AppBar, Highlights
// Secondary	#B0A695 (Warm Taupe)	Text & Icons
// Background	#F4F3EF (Soft Beige White)	Page Background
// Card Color	#FFFFFF (Pure White)	Cards & Containers
// Border Color	#D1D0C5 (Muted Stone Gray)	Dividers & Borders
// Accent	#E8A87C (Muted Coral)	Highlights & Notifications
// Error	#D72638 (Elegant Red)	Errors & Alerts