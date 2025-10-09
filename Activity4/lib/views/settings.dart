import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkTheme = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkTheme = value;
      // Note: Theme change not implemented; add ThemeProvider for full functionality
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Theme switched to ${_isDarkTheme ? 'Dark' : 'Light'}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blue.shade100,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings, size: 80, color: Colors.blue),
                    SizedBox(height: 8),
                    Text(
                      'Customize Your Experience',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preferences',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      // Task 5: Theme switch
                      SwitchListTile(
                        title: const Text('Dark Theme'),
                        value: _isDarkTheme,
                        onChanged: _toggleTheme,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Log Out',
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        },
                        type: ButtonType.elevated,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        icon: Icons.logout,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
