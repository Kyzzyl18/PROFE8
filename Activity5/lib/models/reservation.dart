import 'package:flutter/material.dart';
import 'user.dart';

enum Bundle {
  bronze,
  silver,
  golden,
  platinum,
}

enum AdditionalItem {
  smokeMachine,
  movingHeadLights,
  ledWall,
}

class Reservation {
  final User user;
  final Bundle bundle;
  final List<AdditionalItem> additionalItems;
  final bool isUrgent;
  final DateTime date;
  final TimeOfDay time;
  final bool paid;
  final double deliveryFee;
  final String notes;

  Reservation({
    required this.user,
    required this.bundle,
    required this.additionalItems,
    required this.isUrgent,
    required this.date,
    required this.time,
    required this.paid,
    required this.deliveryFee,
    required this.notes,
  });

  Reservation copyWith({
    User? user,
    Bundle? bundle,
    List<AdditionalItem>? additionalItems,
    bool? isUrgent,
    DateTime? date,
    TimeOfDay? time,
    bool? paid,
    double? deliveryFee,
    String? notes,
  }) {
    return Reservation(
      user: user ?? this.user,
      bundle: bundle ?? this.bundle,
      additionalItems: additionalItems ?? this.additionalItems,
      isUrgent: isUrgent ?? this.isUrgent,
      date: date ?? this.date,
      time: time ?? this.time,
      paid: paid ?? this.paid,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      notes: notes ?? this.notes,
    );
  }

  static Map<Bundle, Map<String, dynamic>> bundleDetails = {
    Bundle.bronze: {
      'name': 'Bronze Bundle',
      'description':
          '2 Kevler 12 inch Powered Speakers, 2 Microphones, 4 PARLED Lights w/ Stand, Mixer and Light Controller',
      'price': 5000,
      'image': 'assets/images/bronze_bundle.png',
    },
    Bundle.silver: {
      'name': 'Silver Bundle',
      'description':
          '2 Kevler 15 inch Powered Speakers, 1 Kevler Powered Subwoofer, 2 Microphones, 8 PARLED Lights w/ Stand, Mixer and Light Controller',
      'price': 8000,
      'image': 'assets/images/silver_bundle.png',
    },
    Bundle.golden: {
      'name': 'Golden Bundle',
      'description':
          '4 Kevler 15 inch Powered Speakers, 2 Kevler Powered Subwoofer, 2 Microphones, 12 PARLED Lights w/ Stand, Mixer and Light Controller',
      'price': 12000,
      'image': 'assets/images/golden_bundle.png',
    },
    Bundle.platinum: {
      'name': 'Platinum Bundle',
      'description':
          '8 Kevler 15 inch Powered Speakers, 4 Kevler Powered Subwoofer, 2 Microphones, 16 PARLED Lights w/ Stand, Mixer and Light Controller',
      'price': 20000,
      'image': 'assets/images/platinum_bundle.png',
    },
  };

  static Map<AdditionalItem, Map<String, dynamic>> additionalItemDetails = {
    AdditionalItem.smokeMachine: {
      'name': 'Smoke Machine',
      'price': 500,
    },
    AdditionalItem.movingHeadLights: {
      'name': '2 Moving Head Lights',
      'price': 1000,
    },
    AdditionalItem.ledWall: {
      'name': 'LED Wall',
      'price': 8000,
    },
  };
}
