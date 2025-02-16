import 'package:flutter/material.dart';
import 'package:ride_spot/theme/custom_colors.dart';

class SmallTextbutton extends StatelessWidget {
  final String buttomName;
  final VoidCallback voidCallBack;
  final Color buttomColor;
  final Color textColor;
  final Color? borderColor;
  final double width;
  final double fontweight;

  const SmallTextbutton({
    super.key,
    this.borderColor,
    required this.buttomName,
    required this.voidCallBack,
    this.buttomColor = Colors.black,
    this.textColor = Colors.white,
    this.width = 0,
    this.fontweight = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: buttomColor,
          border: Border.all(
              width: width, color: borderColor ?? CustomColor.lightpurple),
          borderRadius: BorderRadius.circular(9),
        ),
        height: 37,
        width: 130, // Fixed height for button
        child: TextButton(
          style: TextButton.styleFrom(
            minimumSize: const Size(double.infinity, 57),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: voidCallBack,
          child: Text(
            buttomName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ));
  }
}
