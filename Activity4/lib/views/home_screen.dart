import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../models/user.dart';
import '../services/reservation_service.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _messageController = TextEditingController();
  final List<String> _messages = [];
  Reservation? _pendingReservation;
  int _selectedIndex = 0;

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

  void _reserveBundle(Bundle bundle, User user) async {
    final result = await Navigator.pushNamed(
      context,
      '/reservation-form',
      arguments: {'bundle': bundle, 'user': user},
    );
    if (result is Reservation) {
      setState(() {
        _pendingReservation = result;
      });
    }
  }

  void _confirmReservation() {
    if (_pendingReservation != null) {
      ReservationService.addReservation(_pendingReservation!);
      setState(() {
        _pendingReservation = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${Reservation.bundleDetails[_pendingReservation!.bundle]!['name']} confirmed!')),
      );
    }
  }

  void _onNavBarTap(int index, User user) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.pushNamed(context, '/profile', arguments: user);
    } else if (index == 2) {
      Navigator.pushNamed(context, '/settings');
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
    final user = ModalRoute.of(context)!.settings.arguments as User;
    final reservations = ReservationService.getReservations();

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('AVReserve Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              title: const Text('Contact'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('AV Reservation'),
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
        currentIndex: _selectedIndex,
        onTap: (index) => _onNavBarTap(index, user),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Home tab: Hero + List
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.blue.shade100,
                  child: const Center(
                    child: Text(
                      'Welcome to AVReserve!\nRent Professional Audio-Visual Equipment',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                              Text(
                                entry.value['name'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.value['description'],
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Price: Php ${entry.value['price']}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              CustomButton(
                                text: 'Reserve',
                                onPressed: () =>
                                    _reserveBundle(entry.key, user),
                                type: ButtonType.elevated,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                icon: Icons.check,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_pendingReservation != null) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Pending Reservation:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Bundle: ${Reservation.bundleDetails[_pendingReservation!.bundle]!['name']}'),
                          Text(
                              'Price: Php ${Reservation.bundleDetails[_pendingReservation!.bundle]!['price']}'),
                          if (_pendingReservation!.additionalItems.isNotEmpty)
                            Text(
                                'Additional Items: ${_pendingReservation!.additionalItems.map((item) => Reservation.additionalItemDetails[item]!['name']).join(', ')}'),
                          if (_pendingReservation!.additionalItems.isNotEmpty)
                            Text(
                                'Additional Cost: Php ${_pendingReservation!.additionalItems.fold<int>(0, (sum, item) => sum + (Reservation.additionalItemDetails[item]!['price'] as int))}'),
                          Text(
                              'Delivery Fee: Php ${_pendingReservation!.deliveryFee}'),
                          Text(
                              'Date: ${_pendingReservation!.date.toString().split(' ')[0]}'),
                          Text(
                              'Time: ${_pendingReservation!.time.format(context)}'),
                          if (_pendingReservation!.notes.isNotEmpty)
                            Text('Notes: ${_pendingReservation!.notes}'),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: 'Confirm Reservation',
                            onPressed: _confirmReservation,
                            type: ButtonType.elevated,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            icon: Icons.check_circle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Confirmed Reservations:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                reservations.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No confirmed reservations yet'),
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
                                  Text('Name: ${res.user.name}'),
                                  Text('Email: ${res.user.email}'),
                                  Text('Role: ${res.user.role}'),
                                  Text(
                                      'Bundle: ${Reservation.bundleDetails[res.bundle]!['name']}'),
                                  Text(
                                      'Price: Php ${Reservation.bundleDetails[res.bundle]!['price']}'),
                                  if (res.additionalItems.isNotEmpty)
                                    Text(
                                        'Additional Items: ${res.additionalItems.map((item) => Reservation.additionalItemDetails[item]!['name']).join(', ')}'),
                                  if (res.additionalItems.isNotEmpty)
                                    Text(
                                        'Additional Cost: Php ${res.additionalItems.fold<int>(0, (sum, item) => sum + (Reservation.additionalItemDetails[item]!['price'] as int))}'),
                                  Text('Delivery Fee: Php ${res.deliveryFee}'),
                                  Text(
                                      'Date: ${res.date.toString().split(' ')[0]}'),
                                  Text('Time: ${res.time.format(context)}'),
                                  Text('Paid: ${res.paid ? 'Yes' : 'No'}'),
                                  if (res.notes.isNotEmpty)
                                    Text('Notes: ${res.notes}'),
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
                    title: Text(_messages[index]),
                    leading: const Icon(Icons.message),
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
                        decoration:
                            const InputDecoration(labelText: 'Send a message'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // My Reservations tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Reservations',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                reservations.isEmpty
                    ? const Expanded(
                        child: Center(
                            child: Text('No reservations yet',
                                style: TextStyle(fontSize: 18))),
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
                                        'Bundle: ${Reservation.bundleDetails[res.bundle]!['name']}'),
                                    Text(
                                        'Price: Php ${Reservation.bundleDetails[res.bundle]!['price']}'),
                                    if (res.additionalItems.isNotEmpty)
                                      Text(
                                          'Additional Items: ${res.additionalItems.map((item) => Reservation.additionalItemDetails[item]!['name']).join(', ')}'),
                                    if (res.additionalItems.isNotEmpty)
                                      Text(
                                          'Additional Cost: Php ${res.additionalItems.fold<int>(0, (sum, item) => sum + (Reservation.additionalItemDetails[item]!['price'] as int))}'),
                                    Text(
                                        'Delivery Fee: Php ${res.deliveryFee}'),
                                    Text(
                                        'Date: ${res.date.toString().split(' ')[0]}'),
                                    Text('Time: ${res.time.format(context)}'),
                                    Text('Paid: ${res.paid ? 'Yes' : 'No'}'),
                                    if (res.notes.isNotEmpty)
                                      Text('Notes: ${res.notes}'),
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
