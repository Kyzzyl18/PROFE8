import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reservation.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _eventNameController = TextEditingController();
  final _eventLocationController = TextEditingController();
  String? _selectedDate;
  String? _selectedTime;
  String? _displayedNote;
  final Map<Additional, bool> _selectedAdditionals = {};
  bool _isDelivered = false;
  Reservation? _confirmedReservation;

  @override
  void initState() {
    super.initState();
    for (var additional in additionalList) {
      _selectedAdditionals[additional] = false;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _eventNameController.dispose();
    _eventLocationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final package = ModalRoute.of(context)!.settings.arguments as Package;
    return Scaffold(
      appBar: AppBar(title: Text('Reserve ${package.name}')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _eventNameController,
                  decoration: InputDecoration(labelText: 'Event Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Event name cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _eventLocationController,
                  decoration: InputDecoration(labelText: 'Event Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Event location cannot be empty';
                    }
                    return null;
                  },
                ),
                ListTile(
                  title: Text(_selectedDate ?? 'Select Date'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
                ListTile(
                  title: Text(_selectedTime ?? 'Select Time'),
                  trailing: Icon(Icons.access_time),
                  onTap: () => _selectTime(context),
                ),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Event Notes (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_displayedNote != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Captured Note: $_displayedNote',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                SizedBox(height: 10),
                Text('Additionals:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...additionalList.map((additional) {
                  return CheckboxListTile(
                    title: Text(
                        '${additional.name} (Php ${additional.price.toStringAsFixed(0)})'),
                    value: _selectedAdditionals[additional],
                    onChanged: (value) {
                      setState(() {
                        _selectedAdditionals[additional] = value!;
                      });
                    },
                  );
                }).toList(),
                SwitchListTile(
                  title: Text('Delivery (Php 350)'),
                  value: _isDelivered,
                  onChanged: (value) {
                    setState(() {
                      _isDelivered = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _selectedDate != null &&
                        _selectedTime != null) {
                      setState(() {
                        _displayedNote = _noteController.text.isEmpty
                            ? 'No notes provided'
                            : _noteController.text; // Instruction #9
                        final selectedAdditionalNames = _selectedAdditionals
                            .entries
                            .where((entry) => entry.value)
                            .map((entry) => entry.key.name)
                            .toList();
                        final additionalPrice = _selectedAdditionals.entries
                            .where((entry) => entry.value)
                            .fold(0.0, (sum, entry) => sum + entry.key.price);
                        final deliveryPrice = _isDelivered ? 350.0 : 0.0;
                        final totalPrice =
                            package.price + additionalPrice + deliveryPrice;
                        final deposit = totalPrice * 0.5;
                        _confirmedReservation = Reservation(
                          username: currentUsername ?? 'User',
                          email: 'user@example.com',
                          package: package.name,
                          additionals: selectedAdditionalNames,
                          isDelivered: _isDelivered,
                          date: _selectedDate!,
                          time: _selectedTime!,
                          eventName: _eventNameController.text,
                          eventLocation: _eventLocationController.text,
                          deposit: deposit,
                          totalPrice: totalPrice,
                          note: _noteController.text,
                        );
                        reservations.add(
                            _confirmedReservation!); // Save to list (Instruction #10)
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reservation Confirmed')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Please complete all required fields')),
                      );
                    }
                  },
                  child: Text('Confirm Reservation'),
                ),
                if (_confirmedReservation != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reservation Details:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Package: ${_confirmedReservation!.package}\n'
                          'Additionals: ${_confirmedReservation!.additionals.isEmpty ? "None" : _confirmedReservation!.additionals.join(", ")}\n'
                          'Delivery: ${_confirmedReservation!.isDelivered ? "Yes (Php 350)" : "No"}\n'
                          'Username: ${_confirmedReservation!.username}\n'
                          'Event Name: ${_confirmedReservation!.eventName}\n'
                          'Event Location: ${_confirmedReservation!.eventLocation}\n'
                          'Date: ${_confirmedReservation!.date}\n'
                          'Time: ${_confirmedReservation!.time}\n'
                          'Note: ${_confirmedReservation!.note.isEmpty ? "None" : _confirmedReservation!.note}\n'
                          'Deposit: Php ${_confirmedReservation!.deposit.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/my_reservations');
                          },
                          child: Text('View My Reservations'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
