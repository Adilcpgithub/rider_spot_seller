//CustomTextbutton
import 'package:flutter/material.dart';

class CustomTextbutton extends StatelessWidget {
  final String buttomName;
  final VoidCallback voidCallBack;
  final Color buttonColor;
  final Color textColor;

  final bool isLoading;
  const CustomTextbutton(
      {super.key,
      required this.buttomName,
      required this.voidCallBack,
      this.buttonColor = Colors.black,
      this.textColor = Colors.white,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 57, // Fixed height for button
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(double.infinity, 57),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: buttonColor,
        ),
        onPressed: voidCallBack,
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                buttomName,
                style: TextStyle(color: textColor, fontSize: 18),
              ),
      ),
    );
  }
}
