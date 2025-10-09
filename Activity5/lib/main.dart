import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'views/login.dart';
import 'views/signin.dart';
import 'views/home_screen.dart';
import 'views/reservation_form.dart';
import 'views/profile.dart';
import 'views/settings.dart';
import 'views/about.dart';
import 'views/contact.dart';
import 'views/media_player.dart';
import 'views/gallery.dart';
import 'models/reservation.dart';
import 'models/user.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const AVReserveApp(),
    ),
  );
}

class AVReserveApp extends StatelessWidget {
  const AVReserveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AVReserve',
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signin': (context) => const SignInScreen(),
        '/home': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return HomeScreen(user: user);
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
          return ProfileScreen(user: user);
        },
        '/settings': (context) => const SettingsScreen(),
        '/about': (context) => const AboutScreen(),
        '/contact': (context) => const ContactScreen(),
        '/media-player': (context) => const MediaPlayerScreen(),
        '/gallery': (context) => const GalleryScreen(),
      },
    );
  }
}
