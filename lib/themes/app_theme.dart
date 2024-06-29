import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 43, 153, 58);

  static ThemeData get miguelTheme => ThemeData(
        primaryColor: primaryColor,
        appBarTheme: const AppBarTheme(
          color: primaryColor,
          elevation: 2,
        ),
      );
}
