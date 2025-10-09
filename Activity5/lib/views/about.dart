import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  final List<String> images = const [
    'assets/images/bronze_bundle.png',
    'assets/images/silver_bundle.png',
    'assets/images/golden_bundle.png',
    'assets/images/platinum_bundle.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About AVReserve',
            style: TextStyle(fontFamily: 'Roboto')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRIp_ErIcmPS-D0vTzHN2JfSwfx2WEmkQTgZg&s',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      'About AVReserve',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        shadows: const [
                          Shadow(blurRadius: 5, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Equipment Preview',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ),
            SizedBox(
              height: 200,
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'AVReserve is dedicated to providing top-quality audio-visual equipment rentals for events of all sizes. Whether you’re hosting a small gathering or a large concert, our bundles are designed to meet your needs with professional-grade speakers, microphones, lighting, and more.',
                        style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Why Choose Us?',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '- Affordable pricing with flexible bundles\n- Easy reservation process\n- Reliable delivery options\n- 24/7 customer support',
                        style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
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
