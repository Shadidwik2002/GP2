import 'package:flutter/material.dart';
import 'provider_profile.dart';
import 'provider_schedule.dart';
import 'api_service.dart'; // Import your ApiService class
import 'user_data.dart'; // Import the UserData singleton

class ServiceProviderDashboard extends StatefulWidget {
  const ServiceProviderDashboard({super.key});

  @override
  _ServiceProviderDashboardState createState() =>
      _ServiceProviderDashboardState();
}

class _ServiceProviderDashboardState extends State<ServiceProviderDashboard> {
  int _currentIndex = 0;
  final ApiService apiService = ApiService(baseUrl: 'https://your-api-url.com'); // Initialize ApiService

  List<Map<String, String>> requests = [];
  final List<Map<String, String>> acceptedRequests = [];
  final List<Map<String, String>> serviceHistory = [];
  String providerStatus = 'Available';

  @override
  void initState() {
    super.initState();
    _fetchServiceRequests(); // Fetch service requests from the API
    _fetchProviderData(); // Fetch provider details (status, etc.)
  }

  Future<void> _fetchServiceRequests() async {
    final providerId = UserData().id; // Use providerId from UserData
    if (providerId == null) {
      print('Error: Provider ID is null.');
      return;
    }

    try {
      final response = await apiService.get(
          '/api/ProviderDashboard/bookings?providerId=$providerId'); // Use providerId
      if (response != null && response is List) {
        setState(() {
          requests = List<Map<String, String>>.from(response.map((item) {
            return {
              'id': item['id'],
              'service': item['service'],
              'customerName': item['customerName'],
              'details': item['details'],
              'time': item['time'],
              'location': item['location'],
              'status': item['status'] ?? 'Pending', // Added the status key for tracking
            };
          }));
        });
      } else {
        print('Error: No service requests found.');
      }
    } catch (e) {
      print('Error fetching service requests: $e');
    }
  }

  Future<void> _fetchProviderData() async {
    final providerId = UserData().id; // Use providerId from UserData
    if (providerId == null) {
      print('Error: Provider ID is null.');
      return;
    }

    try {
      final response = await apiService.get(
          '/api/ProviderDashboard/profile?providerId=$providerId'); // Use providerId
      if (response != null) {
        setState(() {
          providerStatus = response['status'] ?? 'Available'; // Set provider status from API
        });
      } else {
        print('Error fetching provider data');
      }
    } catch (e) {
      print('Error fetching provider data: $e');
    }
  }

  void toggleStatus() {
    setState(() {
      providerStatus = providerStatus == 'Available' ? 'Busy' : 'Available';
    });
    updateProviderStatus(providerStatus);
  }

  Future<void> updateProviderStatus(String status) async {
    final providerId = UserData().id; // Use providerId from UserData
    if (providerId == null) {
      print('Error: Provider ID is null.');
      return;
    }

    try {
      final response = await apiService.post(
        '/api/ProviderDashboard/status',
        {
          'providerId': providerId, // Use providerId
          'status': status,
        },
      );

      if (response != null) {
        print('Status updated to $status');
      } else {
        print('Failed to update status');
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      Container(
        color: Colors.white,
        child: requests.isEmpty
            ? const Center(
                child: Text(
                  'No new requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Service: ${request['service']}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text('Customer: ${request['customerName']}'),
                          const SizedBox(height: 5),
                          Text('Details: ${request['details']}'),
                          const SizedBox(height: 5),
                          Text('Time: ${request['time']}'),
                          const SizedBox(height: 5),
                          Text('Location: ${request['location']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      ProviderSchedulePage(), // Pass only relevant data
      ProviderProfilePage(serviceHistory: serviceHistory), // Pass only relevant data
    ];

    final List<String> titles = ['Dashboard', 'Schedule', 'Profile'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(titles[_currentIndex]),
        centerTitle: true,
        elevation: 0,
        actions: _currentIndex == 0
            ? [
                GestureDetector(
                  onTap: toggleStatus,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: providerStatus == 'Available' ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      providerStatus,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Schedule',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
