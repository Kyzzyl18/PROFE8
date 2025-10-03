class Package {
  final String name;
  final String components;
  final double price;

  Package({
    required this.name,
    required this.components,
    required this.price,
  });
}

class Additional {
  final String name;
  final double price;

  Additional({
    required this.name,
    required this.price,
  });
}

class Reservation {
  final String username;
  final String email;
  final String package; // Single package name
  final List<String> additionals; // List of selected additional items
  final bool isDelivered; // Delivery flag
  final String date;
  final String time;
  final String eventName;
  final String eventLocation;
  final double deposit;
  final double totalPrice;
  final String note;
  bool isPaid;

  Reservation({
    required this.username,
    required this.email,
    required this.package,
    required this.additionals,
    required this.isDelivered,
    required this.date,
    required this.time,
    required this.eventName,
    required this.eventLocation,
    required this.deposit,
    required this.totalPrice,
    required this.note,
    this.isPaid = false,
  });
}

// Sample package data
List<Package> packageList = [
  Package(
    name: 'Bronze Package',
    components:
        '2 Speakers, 2 Microphones, 16 Channel Mixer, 8 pcs. PARLED Lights, Light Console, Amplifiers',
    price: 5000.0,
  ),
  Package(
    name: 'Silver Package',
    components:
        '4 Speakers, 2 Microphones, 16 Channel Mixer, 2 Beam Lights, 16 pcs. PARLED Lights, Light Console, Amplifiers',
    price: 8000.0,
  ),
  Package(
    name: 'Gold Package',
    components:
        '4 Speakers, 2 Subwoofers, 4 Microphones, 16 Channel Mixer, 2 Beam Lights, 16 PARLED Lights, Light Console, Amplifiers',
    price: 10000.0,
  ),
];

// Available additionals
List<Additional> additionalList = [
  Additional(name: 'Smoke Machine', price: 500.0),
  Additional(name: 'LED Wall', price: 10000.0),
  Additional(name: 'Fog Machine', price: 500.0),
  Additional(name: '2 Microphones', price: 500.0),
];

// Local reservation list
List<Reservation> reservations = [];

// Global username (simplified for demo, use state management in production)
String? currentUsername;
