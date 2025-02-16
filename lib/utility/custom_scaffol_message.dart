import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showUpdateNotification({
  required BuildContext context,
  required String message,
  int? milliseconds,
  Color? color = Colors.green,
  IconData icon = Icons.check_circle,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Text(
            overflow: TextOverflow.clip,
            message,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(30),
      duration: Duration(milliseconds: milliseconds ?? 2000),
    ),
  );
}
