import 'package:flutter/material.dart';
import '../models/reservation.dart';

class MyReservationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Reservations')),
      body: reservations.isEmpty
          ? Center(child: Text('No reservations yet'))
          : ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                return ListTile(
                  title: Text(
                      '${reservation.package} ${reservation.additionals.isEmpty ? "" : "+ ${reservation.additionals.join(", ")}"}'),
                  subtitle: Text(
                      'Date: ${reservation.date}, Time: ${reservation.time}, Delivery: ${reservation.isDelivered ? "Yes" : "No"}, Paid: ${reservation.isPaid ? "Yes" : "No"}'),
                  trailing: reservation.isPaid
                      ? null
                      : ElevatedButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/payment',
                            arguments: reservation,
                          ),
                          child: Text('Pay Now'),
                        ),
                );
              },
            ),
    );
  }
}
