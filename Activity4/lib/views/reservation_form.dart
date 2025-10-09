import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../models/user.dart';
import '../widgets/custom_button.dart';

class ReservationFormScreen extends StatefulWidget {
  final Bundle bundle;
  final User user;

  const ReservationFormScreen(
      {super.key, required this.bundle, required this.user});

  @override
  _ReservationFormScreenState createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _smokeMachineSelected = false;
  bool _movingHeadLightsSelected = false;
  bool _ledWallSelected = false;
  bool _deliverySelected = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
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
        _selectedTime = picked;
      });
    }
  }

  void _toggleDelivery(bool value) {
    setState(() {
      _deliverySelected = value;
      if (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Delivery selected: Php 300 fee will be added')),
        );
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final additionalItems = <AdditionalItem>[];
      if (_smokeMachineSelected)
        additionalItems.add(AdditionalItem.smokeMachine);
      if (_movingHeadLightsSelected)
        additionalItems.add(AdditionalItem.movingHeadLights);
      if (_ledWallSelected) additionalItems.add(AdditionalItem.ledWall);

      final reservation = Reservation(
        user: widget.user,
        bundle: widget.bundle,
        additionalItems: additionalItems,
        isUrgent: false,
        date: _selectedDate ?? DateTime.now(),
        time: _selectedTime ?? TimeOfDay.now(),
        paid: false,
        deliveryFee: _deliverySelected ? 300.0 : 0.0,
        notes: _notesController.text,
      );

      Navigator.pop(context, reservation);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Reserve ${Reservation.bundleDetails[widget.bundle]!['name']}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomButton(
                text: _selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${_selectedDate!.toString().split(' ')[0]}',
                onPressed: () => _selectDate(context),
                type: ButtonType.outlined,
                borderColor: Colors.blue,
                textColor: Colors.blue,
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: _selectedTime == null
                    ? 'Select Time'
                    : 'Time: ${_selectedTime!.format(context)}',
                onPressed: () => _selectTime(context),
                type: ButtonType.outlined,
                borderColor: Colors.blue,
                textColor: Colors.blue,
                icon: Icons.access_time,
              ),
              const SizedBox(height: 16),
              const Text('Additional Items:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: const Text('Smoke Machine (Php 500)'),
                value: _smokeMachineSelected,
                onChanged: (value) =>
                    setState(() => _smokeMachineSelected = value!),
              ),
              CheckboxListTile(
                title: const Text('2 Moving Head Lights (Php 1000)'),
                value: _movingHeadLightsSelected,
                onChanged: (value) =>
                    setState(() => _movingHeadLightsSelected = value!),
              ),
              CheckboxListTile(
                title: const Text('LED Wall (Php 8000)'),
                value: _ledWallSelected,
                onChanged: (value) => setState(() => _ledWallSelected = value!),
              ),
              SwitchListTile(
                title: const Text('Delivery (Php 300)'),
                value: _deliverySelected,
                onChanged: _toggleDelivery,
              ),
              TextFormField(
                controller: _notesController,
                decoration:
                    const InputDecoration(labelText: 'Additional Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Submit Reservation',
                onPressed: _submitForm,
                type: ButtonType.elevated,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                icon: Icons.check,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
