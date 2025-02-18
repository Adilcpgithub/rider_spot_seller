import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ride_spot/features/auth/presentation/screens/login_screen.dart';
import 'package:ride_spot/features/dashboard/presentation/widget/small_text_button.dart';
import 'package:ride_spot/utility/app_logo.dart';
import 'package:ride_spot/utility/navigation.dart';

showModelDeletingRule(BuildContext context) async {
  showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: deviceWidth(context) - deviceWidth(context) / 4,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.grey),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Confirmation!',
                  style: TextStyle(
                    decorationThickness: 0,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SmallTextbutton(
                          width: 1.5,
                          textColor: Colors.black,
                          buttomName: 'cancel',
                          fontweight: 16,
                          voidCallBack: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: SmallTextbutton(
                          width: 1.5,
                          textColor: Colors.black,
                          buttomName: 'logout',
                          fontweight: 16,
                          voidCallBack: () async {
                            log('true pressed');

                            CustomNavigation.pushAndRemoveUntil(
                                context, const LoginScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
