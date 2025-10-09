import 'package:flutter/material.dart';
import 'views/login.dart';
import 'views/signin.dart';
import 'views/home_screen.dart';
import 'views/reservation_form.dart';
import 'views/profile.dart';
import 'views/settings.dart';
import 'views/about.dart';
import 'views/contact.dart';
import 'models/reservation.dart';
import 'models/user.dart';

void main() {
  runApp(const AVReserveApp());
}

class AVReserveApp extends StatelessWidget {
  const AVReserveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AVReserve',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signin': (context) => const SignInScreen(),
        '/home': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return HomeScreen();
        },
        '/reservation-form': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return ReservationFormScreen(
            bundle: args['bundle'] as Bundle,
            user: args['user'] as User,
          );
        },
        '/profile': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return ProfileScreen();
        },
        '/settings': (context) => const SettingsScreen(),
        '/about': (context) => const AboutScreen(),
        '/contact': (context) => const ContactScreen(),
      },
    );
  }
}
