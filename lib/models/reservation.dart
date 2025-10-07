import 'package:flutter/material.dart';

class Reservation {
  final String username;
  final String name;
  final String email;
  final String password;
  final String role;
  final bool hasCheckbox;
  final bool hasSwitch;
  final DateTime date;
  final TimeOfDay time;

  Reservation({
    required this.username,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.hasCheckbox,
    required this.hasSwitch,
    required this.date,
    required this.time,
  });
}
