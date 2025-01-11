import 'package:flutter/material.dart';
import 'api_service.dart';
import 'account_page.dart';
import 'Provider_List.dart';
import 'reschedule_screen.dart';
import 'user_data.dart'; // Import UserData singleton

class Appointment {
  String id;
  String providerName;
  String issueDescription;
  String date;
  String time;

  Appointment({
    required this.id,
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
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5196');
  final List<Appointment> _appointments = [];
  final List<Appointment> _allAppointments = [];
  List<Map<String, dynamic>> _services = [];
  String _searchQuery = '';
  bool isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchServices();
    _fetchAppointments();
  }

  Future<void> _fetchServices() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await apiService.get('/api/AdminDashboard/services');
      if (response is List) {
        setState(() {
          _services = response.map((service) {
            return {
              'id': service['id'],
              'title': service['name'],
              'price': '${service['price']} JD',
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

    final userId = UserData().id; // Get the userId from UserData
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User ID not available.')),
      );
      return;
    }

    try {
      final response = await apiService.get('/api/UserDashboard/appointments?userId=$userId');
      if (response is List) {
        setState(() {
          _appointments.clear();
          for (var item in response) {
            _appointments.add(Appointment(
              id: item['id'].toString(),
              providerName: item['serviceProviderName'] ?? 'Unknown Provider',
              issueDescription: item['serviceName'] ?? 'No description',
              date: item['appointmentDate']?.split('T')?.first ?? 'N/A',
              time: item['appointmentDate']?.split('T')?.last ?? 'N/A',
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
        SnackBar(
          content: Text('Booking rescheduled to ${appointment.date} at ${appointment.time}'),
        ),
      );
    }
  }

  Future<void> _cancelAppointment(Appointment appointment) async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await apiService.post('/api/Booking/cancel', {
        "bookingId": appointment.id, // Send the booking ID
      });

      if (response != null) {
        setState(() {
          _appointments.remove(appointment); // Remove the appointment from the list
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment canceled successfully.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel appointment: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.red),
                                ),
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

  Widget _buildServiceCard(String title, String price, String imagePath, BuildContext context, int serviceId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderList(
              serviceId: serviceId,
              onAppointmentBooked: _addAppointment,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
      ),
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
                          'images/electrician.jpg',
                          context,
                          service['id'],
                        );
                      },
                    ),
          _buildSchedulePage(),
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
}
