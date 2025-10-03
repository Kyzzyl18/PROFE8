import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/signup_page.dart';
import 'views/home_page.dart';
import 'views/reservation_page.dart';
import 'views/my_reservations_page.dart';
import 'views/payment_page.dart';

void main() {
  runApp(AVReservationApp());
}

class AVReservationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AV Reservation App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/reservation': (context) => ReservationPage(),
        '/my_reservations': (context) => MyReservationsPage(),
        '/payment': (context) => PaymentPage(),
      },
    );
  }
}
