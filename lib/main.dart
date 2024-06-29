import 'package:flutter/material.dart';
import 'package:pokemon_api/screens/home_screen.dart';
import 'package:pokemon_api/themes/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: const HomeScreen(),
      theme: AppTheme.miguelTheme,
    );
  }
}
