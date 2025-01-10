import 'package:flutter/material.dart';
import 'provider_profile.dart';
import 'provider_schedule.dart';
import 'api_service.dart'; // Import your ApiService class

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
    try {
      final response = await apiService.get('/api/ProviderDashboard/bookings?providerId=123'); // Use actual providerId
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
        // Handle empty or incorrect response
        print('Error: No service requests found.');
      }
    } catch (e) {
      print('Error fetching service requests: $e');
    }
  }

  Future<void> _fetchProviderData() async {
    try {
      final response = await apiService.get('/api/ProviderDashboard/profile?providerId=123'); // Use actual providerId
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

  // Accept request logic
  Future<void> _acceptRequest(String bookingId) async {
    try {
      final response = await apiService.post('/api/ProviderDashboard/accept', {
        'bookingId': bookingId,
        'status': 'Accepted',
      });

      if (response != null) {
        // Update request status locally after success
        setState(() {
          final request = requests.firstWhere((req) => req['id'] == bookingId);
          request['status'] = 'Accepted';
          acceptedRequests.add(request);
          requests.removeWhere((req) => req['id'] == bookingId);
        });
        print('Request Accepted');
      }
    } catch (e) {
      print('Error accepting request: $e');
    }
  }

  // Decline request logic
  Future<void> _declineRequest(String bookingId) async {
    try {
      final response = await apiService.post('/api/ProviderDashboard/decline', {
        'bookingId': bookingId,
        'status': 'Declined',
      });

      if (response != null) {
        // Update request status locally after success
        setState(() {
          final request = requests.firstWhere((req) => req['id'] == bookingId);
          request['status'] = 'Declined';
          requests.removeWhere((req) => req['id'] == bookingId);
        });
        print('Request Declined');
      }
    } catch (e) {
      print('Error declining request: $e');
    }
  }

  void handleRequestConfirmation(String id, bool accepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(accepted ? 'Accept Request' : 'Decline Request'),
          content: Text(
            accepted
                ? 'Are you sure you want to accept this request?'
                : 'Are you sure you want to decline this request?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (accepted) {
                  _acceptRequest(id); // Trigger API call for accept
                } else {
                  _declineRequest(id); // Trigger API call for decline
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void toggleStatus() {
    setState(() {
      providerStatus = providerStatus == 'Available' ? 'Busy' : 'Available';
    });
    updateProviderStatus(providerStatus);
  }

  Future<void> updateProviderStatus(String status) async {
    try {
      final response = await apiService.post(
        '/api/ProviderDashboard/status',
        {
          'providerId': '123', // Use actual provider ID
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
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () => handleRequestConfirmation(request['id']!, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('Accept'),
                              ),
                              ElevatedButton(
                                onPressed: () => handleRequestConfirmation(request['id']!, false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Decline'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      ProviderSchedulePage(acceptedRequests: acceptedRequests),
      ProviderProfilePage(serviceHistory: serviceHistory),
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
      body: Container(
        color: Colors.white,
        child: pages[_currentIndex],
      ),
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
