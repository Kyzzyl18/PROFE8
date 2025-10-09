import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About AVReserve'),
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
                    Icon(Icons.info, size: 80, color: Colors.blue),
                    SizedBox(height: 8),
                    Text(
                      'About AVReserve',
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
                        'Our Mission',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'AVReserve is dedicated to providing top-quality audio-visual equipment rentals for events of all sizes. Whether you’re hosting a small gathering or a large concert, our bundles are designed to meet your needs with professional-grade speakers, microphones, lighting, and more.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Why Choose Us?',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '- Affordable pricing with flexible bundles\n- Easy reservation process\n- Reliable delivery options\n- 24/7 customer support',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Contact Us',
                        onPressed: () {
                          Navigator.pushNamed(context, '/contact');
                        },
                        type: ButtonType.elevated,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        icon: Icons.contact_mail,
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
