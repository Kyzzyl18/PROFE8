import 'package:flutter/material.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const SoundReserveApp());
}

class SoundReserveApp extends StatelessWidget {
  const SoundReserveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound System Reservation',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
