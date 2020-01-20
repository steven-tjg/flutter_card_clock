import 'package:flutter/material.dart';

double getScreenWidthPercentage(double percentage, BuildContext context) {
  return MediaQuery.of(context).size.width * percentage / 100;
}

double getScreenHeightPercentage(double percentage, BuildContext context) {
  return MediaQuery.of(context).size.height * percentage / 100;
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

const SizedBox boxHeightS = SizedBox(height: 10);

const SizedBox boxHeightM = SizedBox(height: 20);

const SizedBox boxHeight = SizedBox(height: 30);

const SizedBox boxWidthXS = SizedBox(width: 5);
