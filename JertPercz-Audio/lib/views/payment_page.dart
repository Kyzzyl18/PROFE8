import 'package:flutter/material.dart';
import '../models/reservation.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reservation =
        ModalRoute.of(context)!.settings.arguments as Reservation;
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                      'Amount Due: Php ${reservation.totalPrice - reservation.deposit}'),
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: InputDecoration(labelText: 'Card Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Card number cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          reservation.isPaid = true; // Save data to local list
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Payment Successful')),
                        );
                      }
                    },
                    child: Text('Complete Payment'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Reservation History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final res = reservations[index];
                  return ListTile(
                    title: Text(
                        '${res.package} ${res.additionals.isEmpty ? "" : "+ ${res.additionals.join(", ")}"}'),
                    subtitle: Text(
                        'Date: ${res.date}, Delivery: ${res.isDelivered ? "Yes" : "No"}, Paid: ${res.isPaid ? "Yes" : "No"}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
