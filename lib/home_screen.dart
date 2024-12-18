import 'package:flutter/material.dart';
import 'account_page.dart'; // Import the AccountPage
import 'BookingScreen.dart'; // Import the BookingScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> _services = [
    {'title': 'House Cleaning', 'price': '15 JD', 'image': 'images/house_cleaning.jpg'},
    {'title': 'Plumbing', 'price': '8 JD', 'image': 'images/plumbing.jpg'},
    {'title': 'Home devices maintenance', 'price': '10 JD', 'image': 'images/devices_maintenance.jpg'},
    {'title': 'Electrician', 'price': '15 JD', 'image': 'images/electrician.jpg'},
  ];

  String _searchQuery = '';
  late List<Map<String, String>> _filteredServices;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredServices = _services;
  }

  void _filterServices(String query) {
    setState(() {
      _searchQuery = query;
      _filteredServices = query.isEmpty
          ? _services
          : _services
              .where((service) => service['title']!.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late final List<Widget> _pages = [
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Builder(
        builder: (context) {
          if (_filteredServices.isEmpty) {
            return const Center(child: Text('No services found.'));
          }
          return ListView.builder(
            itemCount: _filteredServices.length,
            itemBuilder: (context, index) {
              final service = _filteredServices[index];
              return _buildServiceCard(
                service['title']!,
                service['price']!,
                service['image']!,
                context, // Pass context for navigation
              );
            },
          );
        },
      ),
    ),
    const Center(child: Text('Schedule Page - Coming Soon')),
    const AccountPage(), // Navigate to the AccountPage widget
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes all back buttons
        title: _currentIndex == 0
            ? TextField(
                onChanged: _filterServices,
                decoration: InputDecoration(
                  hintText: 'Search for services',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              )
            : Text(_currentIndex == 1 ? 'Schedule' : 'Account'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onTabTapped,
      ),
    );
  }

  static Widget _buildServiceCard(String title, String price, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the BookingScreen when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(serviceTitle: title), // Pass the service title to BookingScreen
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                price,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
