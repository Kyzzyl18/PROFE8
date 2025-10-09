import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../models/user.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_button.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _messageController = TextEditingController();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(_messageController.text);
        _messageController.clear();
      });
    }
  }

  void _reserveBundle(BuildContext context, Bundle bundle) async {
    final result = await Navigator.pushNamed(
      context,
      '/reservation-form',
      arguments: {'bundle': bundle, 'user': widget.user},
    );
    if (result is Reservation) {
      context.read<CartProvider>().addPendingReservation(result);
    }
  }

  void _onNavBarTap(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/profile', arguments: widget.user);
    } else if (index == 2) {
      Navigator.pushNamed(context, '/settings');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/media-player');
    } else if (index == 4) {
      Navigator.pushNamed(context, '/gallery');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final reservations = cartProvider.reservations;
    final pendingReservations = cartProvider.pendingReservations;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'AVReserve Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            ListTile(
              title:
                  const Text('Home', style: TextStyle(fontFamily: 'Poppins')),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title:
                  const Text('About', style: TextStyle(fontFamily: 'Poppins')),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              title: const Text('Contact',
                  style: TextStyle(fontFamily: 'Poppins')),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('AV Reservation',
            style: TextStyle(fontFamily: 'Roboto')),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Home', icon: Icon(Icons.home)),
            Tab(text: 'Chats/Calls', icon: Icon(Icons.chat)),
            Tab(text: 'My Reservations', icon: Icon(Icons.book)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: _onNavBarTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_circle), label: 'Media'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Gallery'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Home tab: Hero + List + GridView
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero section with network image
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
                          'Welcome to AVReserve!\nRent Professional Audio-Visual Equipment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
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
                // GridView of bundle images
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: Reservation.bundleDetails.length,
                    itemBuilder: (context, index) {
                      final entry =
                          Reservation.bundleDetails.entries.elementAt(index);
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          entry.value['image'],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                // Bundle list
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: Reservation.bundleDetails.length,
                    itemBuilder: (context, index) {
                      final entry =
                          Reservation.bundleDetails.entries.elementAt(index);
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  entry.value['image'],
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.value['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.value['description'],
                                style: const TextStyle(
                                    fontSize: 14, fontFamily: 'Roboto'),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Price: Php ${entry.value['price']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 16),
                              CustomButton(
                                text: 'Reserve',
                                onPressed: () =>
                                    _reserveBundle(context, entry.key),
                                type: ButtonType.elevated,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                icon: IconPickerIcon(
                                  name: 'check_circle',
                                  data: Icons.check_circle,
                                  pack: IconPack.material,
                                ).data,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Pending reservations (to-do list equivalent)
                if (pendingReservations.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Pending Reservations:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pendingReservations.length,
                    itemBuilder: (context, index) {
                      final res = pendingReservations[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Bundle: ${Reservation.bundleDetails[res.bundle]!['name']}',
                                  style: const TextStyle(fontFamily: 'Roboto')),
                              Text(
                                  'Price: Php ${Reservation.bundleDetails[res.bundle]!['price']}',
                                  style: const TextStyle(fontFamily: 'Roboto')),
                              if (res.additionalItems.isNotEmpty)
                                Text(
                                  'Additional Items: ${res.additionalItems.map((item) => Reservation.additionalItemDetails[item]!['name']).join(', ')}',
                                  style: const TextStyle(fontFamily: 'Roboto'),
                                ),
                              if (res.additionalItems.isNotEmpty)
                                Text(
                                  'Additional Cost: Php ${res.additionalItems.fold<int>(0, (sum, item) => sum + (Reservation.additionalItemDetails[item]!['price'] as int))}',
                                  style: const TextStyle(fontFamily: 'Roboto'),
                                ),
                              Text('Delivery Fee: Php ${res.deliveryFee}',
                                  style: const TextStyle(fontFamily: 'Roboto')),
                              Text('Date: ${res.date.toString().split(' ')[0]}',
                                  style: const TextStyle(fontFamily: 'Roboto')),
                              Text('Time: ${res.time.format(context)}',
                                  style: const TextStyle(fontFamily: 'Roboto')),
                              if (res.notes.isNotEmpty)
                                Text('Notes: ${res.notes}',
                                    style:
                                        const TextStyle(fontFamily: 'Roboto')),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                    text: 'Confirm',
                                    onPressed: () => context
                                        .read<CartProvider>()
                                        .confirmReservation(res),
                                    type: ButtonType.elevated,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    icon: IconPickerIcon(
                                      name: 'check_circle',
                                      data: Icons.check_circle,
                                      pack: IconPack.material,
                                    ).data,
                                  ),
                                  CustomButton(
                                    text: 'Remove',
                                    onPressed: () => context
                                        .read<CartProvider>()
                                        .removePendingReservation(res),
                                    type: ButtonType.outlined,
                                    borderColor: Colors.red,
                                    textColor: Colors.red,
                                    icon: IconPickerIcon(
                                      name: 'delete',
                                      data: Icons.delete,
                                      pack: IconPack.material,
                                    ).data,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
                // Confirmed reservations
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Confirmed Reservations:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                ),
                reservations.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No confirmed reservations yet',
                            style: TextStyle(fontFamily: 'Roboto')),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reservations.length,
                        itemBuilder: (context, index) {
                          final res = reservations[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name: ${res.user.name}',
                                      style: const TextStyle(
                                          fontFamily: 'Roboto')),
                                  Text('Email: ${res.user.email}',
                                      style: const TextStyle(
                                          fontFamily: 'Roboto')),
                                  Text('Role: ${res.user.role}',
                                      style: const TextStyle(
                                          fontFamily: 'Roboto')),
                                  Text(
                                      'Bundle: ${Reservation.bundleDetails[res.bundle]!['name']}',
                                      style: const TextStyle(
                                          fontFamily: 'Roboto')),
                                  Text(
                                      'Price: Php ${Reservation.bundleDetails[res.bundle]!['price']}',
                                      style: const TextStyle(
                                          fontFamily: 'Roboto')),
                                  if (res.additionalItems.isNotEmpty)
                                    Text(
                                      'Additional Items: ${res.additionalItems.map((item) => Reservation.additionalItemDetails[item]!['name']).join(', ')}',
                                      style:
                                          const TextStyle(fontFamily: 'Roboto'),
                                    ),
                                  if (res.additionalItems.isNotEmpty)
                                    Text(
                                      'Additional Cost: Php ${res.additionalItems.fold<int>(0, (sum, item) => sum + (Reservation.additionalItemDetails[item]!['price'] as int))}',
                                      style:
                                          const TextStyle(fontFamily: 'Roboto'),
                                    ),
                                  Text('Delivery Fee: Php ${res.deliveryFee}',
                                      style: const TextStyle(
                                          fontFamily: 'Roboto')),
                                  Text(
                                      'Date: ${res.date.toString().split(' ')[0]}',
                                      style: const TextStyle(
                                          fontFamily: 'Roboto')),
                                  Text('Time: ${res.time.format(context)}',
                                      style: const TextStyle(
                                          fontFamily: 'Roboto')),
                                  Text('Paid: ${res.paid ? 'Yes' : 'No'}',
                                      style: const TextStyle(
                                          fontFamily: 'Roboto')),
                                  if (res.notes.isNotEmpty)
                                    Text('Notes: ${res.notes}',
                                        style: const TextStyle(
                                            fontFamily: 'Roboto')),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
          // Chats/Calls tab
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(_messages[index],
                        style: const TextStyle(fontFamily: 'Roboto')),
                    leading: Icon(
                      Icons.message,
                      color: context.watch<ThemeProvider>().isDarkMode
                          ? Colors.white
                          : Colors.blue,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'Send a message',
                          labelStyle: TextStyle(fontFamily: 'Poppins'),
                        ),
                        style: const TextStyle(fontFamily: 'Roboto'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        IconPickerIcon(
                          name: 'send',
                          data: Icons.send,
                          pack: IconPack.material,
                        ).data,
                        color: Colors.blue,
                        size: 30,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // My Reservations tab (to-do list equivalent)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Reservations',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 16),
                reservations.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: Text(
                            'No reservations yet',
                            style:
                                TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: reservations.length,
                          itemBuilder: (context, index) {
                            final res = reservations[index];
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Bundle: ${Reservation.bundleDetails[res.bundle]!['name']}',
                                        style: const TextStyle(
                                            fontFamily: 'Roboto')),
                                    Text(
                                        'Price: Php ${Reservation.bundleDetails[res.bundle]!['price']}',
                                        style: const TextStyle(
                                            fontFamily: 'Roboto')),
                                    if (res.additionalItems.isNotEmpty)
                                      Text(
                                        'Additional Items: ${res.additionalItems.map((item) => Reservation.additionalItemDetails[item]!['name']).join(', ')}',
                                        style: const TextStyle(
                                            fontFamily: 'Roboto'),
                                      ),
                                    if (res.additionalItems.isNotEmpty)
                                      Text(
                                        'Additional Cost: Php ${res.additionalItems.fold<int>(0, (sum, item) => sum + (Reservation.additionalItemDetails[item]!['price'] as int))}',
                                        style: const TextStyle(
                                            fontFamily: 'Roboto'),
                                      ),
                                    Text('Delivery Fee: Php ${res.deliveryFee}',
                                        style: const TextStyle(
                                            fontFamily: 'Roboto')),
                                    Text(
                                        'Date: ${res.date.toString().split(' ')[0]}',
                                        style: const TextStyle(
                                            fontFamily: 'Roboto')),
                                    Text('Time: ${res.time.format(context)}',
                                        style: const TextStyle(
                                            fontFamily: 'Roboto')),
                                    Text('Paid: ${res.paid ? 'Yes' : 'No'}',
                                        style: const TextStyle(
                                            fontFamily: 'Roboto')),
                                    if (res.notes.isNotEmpty)
                                      Text('Notes: ${res.notes}',
                                          style: const TextStyle(
                                              fontFamily: 'Roboto')),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
