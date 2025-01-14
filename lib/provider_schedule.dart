import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your ApiService class
import 'user_data.dart'; // Import the UserData singleton

class ProviderSchedulePage extends StatefulWidget {
  const ProviderSchedulePage({super.key});

  @override
  _ProviderSchedulePageState createState() => _ProviderSchedulePageState();
}

class _ProviderSchedulePageState extends State<ProviderSchedulePage> {
  final ApiService apiService = ApiService(baseUrl: 'https://your-api-url.com'); // Initialize ApiService
  List<Map<String, String>> acceptedRequests = []; // Will hold accepted requests

  @override
  void initState() {
    super.initState();
    _fetchAcceptedRequests(); // Fetch accepted requests from the API
  }

  Future<void> _fetchAcceptedRequests() async {
    final providerId = UserData().id; // Fetch providerId from UserData
    if (providerId == null) {
      print('Error: Provider ID is null.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Provider ID not available.')),
      );
      return;
    }

    try {
      final response = await apiService.get(
        '/api/ProviderDashboard/bookings?providerId=$providerId',
      ); // Use providerId from UserData
      if (response != null && response is List) {
        setState(() {
          acceptedRequests = List<Map<String, String>>.from(response.map((item) {
            return {
              'id': item['id'].toString(),
              'service': item['service'],
              'customerName': item['customerName'],
              'time': item['time'],
              'location': item['location'],
              'status': item['status'] ?? 'Pending', // Ensure 'status' exists
            };
          }));
        });
      } else {
        print('Error: No accepted requests found.');
      }
    } catch (e) {
      print('Error fetching accepted requests: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Services'),
        centerTitle: true,
      ),
      body: acceptedRequests.isEmpty
          ? const Center(
              child: Text(
                'No scheduled services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: acceptedRequests.length,
              itemBuilder: (context, index) {
                final request = acceptedRequests[index];
                final statusColor =
                    request['status'] == 'Accepted' ? Colors.green : Colors.red;

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
                        Text('Time: ${request['time']}'),
                        const SizedBox(height: 5),
                        Text('Location: ${request['location']}'),
                        const SizedBox(height: 5),
                        Text(
                          'Status: ${request['status']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
