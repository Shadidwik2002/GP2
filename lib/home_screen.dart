import 'package:flutter/material.dart';
import 'account_page.dart';
import 'Provider_List.dart';
import 'reschedule_screen.dart';

class Appointment {
  String providerName;
  String issueDescription;
  String date;
  String time;

  Appointment({
    required this.providerName,
    required this.issueDescription,
    required this.date,
    required this.time,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Appointment> _appointments = [];
  final List<Appointment> _allAppointments = []; // List to maintain history
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
          : _services.where((service) => service['title']!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _addAppointment(Appointment appointment) {
    setState(() {
      _appointments.add(appointment);
      _allAppointments.add(appointment); // Add to history
      _currentIndex = 1; // Automatically switch to Schedule tab
    });
  }

  void _rescheduleAppointment(Appointment appointment) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RescheduleScreen(appointment: appointment),
      ),
    );
    if (result != null) {
      setState(() {
        appointment.date = result['date'];
        appointment.time = result['time'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking rescheduled to ${appointment.date} at ${appointment.time}')),
      );
    }
  }

  void _cancelAppointment(Appointment appointment) {
    setState(() {
      _appointments.remove(appointment); // Remove from current schedule
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment canceled')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back arrow
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Services Page
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            itemCount: _filteredServices.length,
            itemBuilder: (context, index) {
              final service = _filteredServices[index];
              return _buildServiceCard(service['title']!, service['price']!, service['image']!, context);
            },
          ),

          // Schedule Page
          _buildSchedulePage(),

          // Account Page
          AccountPage(appointments: _allAppointments), // Pass all appointments to history
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildSchedulePage() {
    return _appointments.isEmpty
        ? const Center(child: Text('No appointments scheduled yet.'))
        : ListView.builder(
            itemCount: _appointments.length,
            itemBuilder: (context, index) {
              final appointment = _appointments[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(appointment.providerName),
                        subtitle: Text(
                          'Issue: ${appointment.issueDescription}\nDate: ${appointment.date} at ${appointment.time}',
                        ),
                        leading: const Icon(Icons.event, color: Colors.blue),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => _rescheduleAppointment(appointment),
                            child: const Text('Reschedule'),
                          ),
                          TextButton(
                            onPressed: () => _cancelAppointment(appointment),
                            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildServiceCard(String title, String price, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderList(onAppointmentBooked: _addAppointment),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                imagePath,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}