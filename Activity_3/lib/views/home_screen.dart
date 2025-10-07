import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../services/reservation_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = 'User';
  bool _hasCheckbox = false;
  bool _hasSwitch = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _displayText = '';

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _captureText() {
    setState(() {
      _displayText = _usernameController.text;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final reservation = Reservation(
        username: _usernameController.text,
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole,
        hasCheckbox: _hasCheckbox,
        hasSwitch: _hasSwitch,
        date: _selectedDate ?? DateTime.now(),
        time: _selectedTime ?? TimeOfDay.now(),
      );
      ReservationService.addReservation(reservation);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Reservation submitted and payment simulated!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound System Reservation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 1. Simple form with TextFormField for username
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 16),
                    // 6. Registration form with name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    const SizedBox(height: 16),
                    // 2. Login form with email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      // 3. Form validation
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // 2. Login form with password
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // 6. Confirm password
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // 7. Dropdown menu for role
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      items: ['Admin', 'User', 'Guest']
                          .map((role) =>
                              DropdownMenuItem(value: role, child: Text(role)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedRole = value!),
                      decoration: const InputDecoration(labelText: 'Role'),
                    ),
                    const SizedBox(height: 16),
                    // 5. Checkbox for equipment
                    CheckboxListTile(
                      title: const Text('Microphone'),
                      value: _hasCheckbox,
                      onChanged: (value) =>
                          setState(() => _hasCheckbox = value!),
                    ),
                    // 5. Switch for urgent
                    SwitchListTile(
                      title: const Text('Urgent Reservation'),
                      value: _hasSwitch,
                      onChanged: (value) => setState(() => _hasSwitch = value!),
                    ),
                    const SizedBox(height: 16),
                    // 8. Date picker
                    ElevatedButton(
                      onPressed: _selectDate,
                      child: Text(_selectedDate == null
                          ? 'Select Date'
                          : _selectedDate!.toString()),
                    ),
                    const SizedBox(height: 16),
                    // 8. Time picker
                    ElevatedButton(
                      onPressed: _selectTime,
                      child: Text(_selectedTime == null
                          ? 'Select Time'
                          : _selectedTime!.format(context)),
                    ),
                    const SizedBox(height: 16),
                    // 9. Capture and display text
                    ElevatedButton(
                      onPressed: _captureText,
                      child: const Text('Capture Username'),
                    ),
                    Text(_displayText),
                    const SizedBox(height: 16),
                    // 4. Submit button
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit Reservation'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // 10. Display submitted inputs
              const Text('Submitted Reservations:'),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ReservationService.getReservations().length,
                itemBuilder: (context, index) {
                  final res = ReservationService.getReservations()[index];
                  return ListTile(
                    title: Text(res.name),
                    subtitle: Text('Email: ${res.email}, Role: ${res.role}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
