import 'package:flutter/material.dart';
import 'package:ride_spot/utility/app_logo.dart';

class UserScreenWigets {
  static showProfileDialog(BuildContext context, String imageUrl) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: deviceHeight(context) / 3,
              child: Stack(
                children: [
                  Center(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person_rounded,
                            size: 130, color: Colors.black45);
                      },
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
