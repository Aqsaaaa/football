import 'package:flutter/material.dart';
import 'package:football_app/bottom_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Data Flutter',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}
