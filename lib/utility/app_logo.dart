import 'package:flutter/material.dart';

String appLogo() {
  return 'asset/applogo_whitetheme.png';
}

double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double deviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
