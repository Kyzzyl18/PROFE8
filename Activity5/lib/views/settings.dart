import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_button.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontFamily: 'Roboto')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1516321318423-f06f85e504b3'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Customize Your Experience',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                  ),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Dark Theme',
                            style: TextStyle(fontFamily: 'Roboto')),
                        value: context.watch<ThemeProvider>().isDarkMode,
                        onChanged: (value) {
                          context.read<ThemeProvider>().toggleTheme();
                        },
                        secondary: Icon(
                          IconPickerIcon(
                            name: 'brightness_6',
                            data: Icons.brightness_6,
                            pack: IconPack.material,
                          ).data,
                          color: context.watch<ThemeProvider>().isDarkMode
                              ? Colors.white
                              : Colors.blue,
                          size: 30,
                        ),
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
                        icon: IconPickerIcon(
                          name: 'logout',
                          data: Icons.logout,
                          pack: IconPack.material,
                        ).data,
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
