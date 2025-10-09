import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../models/user.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_button.dart';

class ReservationFormScreen extends StatefulWidget {
  final Bundle bundle;
  final User user;

  const ReservationFormScreen(
      {Key? key, required this.bundle, required this.user})
      : super(key: key);

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

      context.read<CartProvider>().addPendingReservation(reservation);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${Reservation.bundleDetails[reservation.bundle]!['name']} added to cart!')),
      );
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
              'Reserve ${Reservation.bundleDetails[widget.bundle]!['name']}',
              style: const TextStyle(fontFamily: 'Roboto'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  Reservation.bundleDetails[widget.bundle]!['image'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
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
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins')),
              CheckboxListTile(
                title: const Text('Smoke Machine (Php 500)',
                    style: TextStyle(fontFamily: 'Roboto')),
                value: _smokeMachineSelected,
                onChanged: (value) =>
                    setState(() => _smokeMachineSelected = value!),
              ),
              CheckboxListTile(
                title: const Text('2 Moving Head Lights (Php 1000)',
                    style: TextStyle(fontFamily: 'Roboto')),
                value: _movingHeadLightsSelected,
                onChanged: (value) =>
                    setState(() => _movingHeadLightsSelected = value!),
              ),
              CheckboxListTile(
                title: const Text('LED Wall (Php 8000)',
                    style: TextStyle(fontFamily: 'Roboto')),
                value: _ledWallSelected,
                onChanged: (value) => setState(() => _ledWallSelected = value!),
              ),
              SwitchListTile(
                title: const Text('Delivery (Php 300)',
                    style: TextStyle(fontFamily: 'Roboto')),
                value: _deliverySelected,
                onChanged: _toggleDelivery,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                    labelText: 'Additional Notes',
                    hintStyle: TextStyle(fontFamily: 'Roboto')),
                maxLines: 3,
                style: const TextStyle(fontFamily: 'Roboto'),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Add to Cart',
                onPressed: _submitForm,
                type: ButtonType.elevated,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                icon: Icons.add_shopping_cart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
