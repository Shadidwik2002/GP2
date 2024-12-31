import 'package:flutter/material.dart';
import 'provider_profile.dart';
import 'provider_schedule.dart';

class ServiceProviderDashboard extends StatefulWidget {
  const ServiceProviderDashboard({super.key});

  @override
  _ServiceProviderDashboardState createState() => _ServiceProviderDashboardState();
}

class _ServiceProviderDashboardState extends State<ServiceProviderDashboard> {
  int _currentIndex = 0;

  final List<Map<String, String>> requests = [
    {
      'id': '1',
      'service': 'Plumbing',
      'customerName': 'John Doe',
      'details': 'Fix a leaking pipe in the kitchen.',
      'time': '2024-12-27 11:00 AM',
    },
    {
      'id': '2',
      'service': 'Electrical',
      'customerName': 'Jane Smith',
      'details': 'Repair the ceiling fan.',
      'time': '2024-12-27 2:00 PM',
    },
  ];

  final List<Map<String, String>> acceptedRequests = [];
  final List<Map<String, String>> serviceHistory = [];
  String providerStatus = 'Available';

  bool _canAcceptRequest(String requestTime) {
    if (acceptedRequests.isEmpty) return true;

    DateTime newRequestTime = _parseTime(requestTime);
    DateTime lastAcceptedTime = _parseTime(acceptedRequests.last['time']!);

    return newRequestTime.isAfter(lastAcceptedTime.add(const Duration(hours: 2)));
  }

  DateTime _parseTime(String timeString) {
    return DateTime.parse(
        '2024-12-27 ${timeString.split(' ')[0]} ${timeString.split(' ')[1]}');
  }

  void handleRequest(String id, bool accepted) {
    final request =
        requests.firstWhere((element) => element['id'] == id, orElse: () => {});
    if (request.isNotEmpty) {
      if (accepted && !_canAcceptRequest(request['time']!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Cannot accept orders overlapping 2 hours.')),
        );
        return;
      }

      setState(() {
        request['status'] = accepted ? 'Accepted' : 'Declined';
        request['cost'] = accepted ? '50' : '0'; // Example cost
        serviceHistory.add(request);

        if (accepted) {
          acceptedRequests.add(request);
          providerStatus = 'Busy'; // Set status to Busy when an order is accepted
        }

        requests.removeWhere((request) => request['id'] == id);
      });
    }
  }

  void toggleStatus() {
    setState(() {
      providerStatus = providerStatus == 'Available' ? 'Busy' : 'Available';
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      requests.isEmpty
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
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Service: ${request['service']}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text('Customer: ${request['customerName']}'),
                        const SizedBox(height: 5),
                        Text('Details: ${request['details']}'),
                        const SizedBox(height: 5),
                        Text('Time: ${request['time']}'),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () => handleRequest(request['id']!, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Accept'),
                            ),
                            ElevatedButton(
                              onPressed: () => handleRequest(request['id']!, false),
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
      ProviderSchedulePage(acceptedRequests: acceptedRequests),
      ProviderProfilePage(serviceHistory: serviceHistory),
    ];

    final List<String> titles = ['Dashboard', 'Schedule', 'Profile'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back arrow
        title: Text(titles[_currentIndex]),
        centerTitle: true,
        actions: _currentIndex == 0
            ? [
                GestureDetector(
                  onTap: toggleStatus,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: providerStatus == 'Available'
                          ? Colors.green
                          : Colors.red,
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
      bottomNavigationBar: BottomNavigationBar(
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
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}