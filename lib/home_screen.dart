import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your API service
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
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5196'); // Update with your backend URL
  final List<Appointment> _appointments = [];
  final List<Appointment> _allAppointments = [];
  List<Map<String, dynamic>> _services = []; // Replace hardcoded services
  String _searchQuery = '';
  bool isLoading = true; // Track loading state
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchServices(); // Fetch services on screen load
    _fetchAppointments(); // Fetch appointments on screen load
  }

  Future<void> _fetchServices() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await apiService.get('/api/AdminDashboard/services'); // Adjust endpoint if necessary
      if (response is List) {
        setState(() {
          _services = response.map((service) {
            return {
              'id': service['id'],
              'title': service['name'],
              'price': '${service['price']} JD',
              'image': 'images/default_service.jpg', // Placeholder image path
              'description': service['description'],
            };
          }).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching services: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchAppointments() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Fetch scheduled appointments
      final response = await apiService.get('/api/UserDashboard/appointments');
      if (response is List) {
        setState(() {
          _appointments.clear(); // Clear previous appointments
          for (var item in response) {
            _appointments.add(Appointment(
              providerName: item['providerName'] ?? 'Unknown Provider',
              issueDescription: item['issueDescription'] ?? 'No description',
              date: item['appointmentDate']?.split('T')?.first ?? 'N/A', // Extract date
              time: item['appointmentDate']?.split('T')?.last ?? 'N/A', // Extract time
            ));
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching appointments: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterServices(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _addAppointment(Appointment appointment) {
    setState(() {
      _appointments.add(appointment);
      _allAppointments.add(appointment);
      _currentIndex = 1;
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
      _appointments.remove(appointment);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment canceled')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredServices = _services.where((service) {
      final query = _searchQuery.toLowerCase();
      return service['title'].toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredServices.isEmpty
                  ? const Center(child: Text('No services found'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      itemCount: filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = filteredServices[index];
                        return _buildServiceCard(
                          service['title'],
                          service['price'],
                          service['image'],
                          context,
                        );
                      },
                    ),

          // Schedule Page
          _buildSchedulePage(),

          // Account Page
          AccountPage(appointments: _allAppointments),
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
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : _appointments.isEmpty
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
