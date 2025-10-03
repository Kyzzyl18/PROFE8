import 'package:flutter/material.dart';
import '../models/reservation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  bool _showAvailableOnly = false;
  bool _audioFilter = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AV Packages')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Welcome, ${currentUsername ?? "User"}!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Form(
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration:
                            InputDecoration(labelText: 'Search Packages'),
                        onChanged: (value) => setState(() {}),
                      ),
                      CheckboxListTile(
                        title: Text('Show Bronze Only'),
                        value: _showAvailableOnly,
                        onChanged: (value) {
                          setState(() {
                            _showAvailableOnly = value!;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: Text('Show Silver & Gold Only'),
                        value: _audioFilter,
                        onChanged: (value) {
                          setState(() {
                            _audioFilter = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: packageList.length,
              itemBuilder: (context, index) {
                final package = packageList[index];
                if (_searchController.text.isNotEmpty &&
                    !package.name
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase())) {
                  return SizedBox.shrink();
                }
                if (_showAvailableOnly && package.name != 'Bronze Package') {
                  return SizedBox.shrink();
                }
                if (_audioFilter && package.name == 'Bronze Package') {
                  return SizedBox.shrink();
                }
                return Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/reservation',
                      arguments: package,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            package.name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            package.components,
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Price: Php ${package.price.toStringAsFixed(0)}',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/my_reservations'),
                child: Text('My Reservations'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentUsername = null;
                  });
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
