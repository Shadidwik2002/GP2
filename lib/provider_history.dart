import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your API service
import 'user_data.dart'; // Import the UserData singleton

class ProviderHistoryPage extends StatefulWidget {
  const ProviderHistoryPage({super.key});

  @override
  _ProviderHistoryPageState createState() => _ProviderHistoryPageState();
}

class _ProviderHistoryPageState extends State<ProviderHistoryPage> {
  final ApiService apiService = ApiService(baseUrl: 'https://your-api-url.com'); // Initialize ApiService
  List<Map<String, String>> serviceHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServiceHistory(); // Fetch the service history from the API
  }

  Future<void> _fetchServiceHistory() async {
    final providerId = UserData().id; // Fetch providerId from UserData
    if (providerId == null) {
      print('Error: Provider ID is null.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Provider ID not available.')),
      );
      return;
    }

    try {
      final response = await apiService.get('/api/bookings?providerId=$providerId'); // Use providerId dynamically
      if (response != null && response is Map<String, dynamic>) {
        // Flatten the dictionary into a single list of bookings
        final allBookings = response.values.expand((bookings) => bookings).toList();

        // Filter for Completed bookings (or other statuses if needed)
        final completedBookings = allBookings.where((booking) => booking['status'] == 'Completed').toList();

        setState(() {
          serviceHistory = List<Map<String, String>>.from(completedBookings.map((item) {
            return {
              'id': item['id'].toString(),
              'service': 'Service ${item['serviceId']}', // Map serviceId to a service name
              'customerName': 'User ${item['userId']}', // Map userId to a customer name
              'details': item['issueDescription'] ?? 'No details',
              'time': item['appointmentDate'] ?? 'No time',
              'location': 'Location not available', // Add location if available in the API
              'status': item['status'] ?? 'Pending',
              'cost': '0', // Add cost if available in the API
            };
          }));
        });
      } else {
        print('Error: No service history found.');
      }
    } catch (e) {
      print('Error fetching service history: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Service History',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : serviceHistory.isEmpty
              ? const Center(
                  child: Text(
                    'No history available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                )
              : ListView.builder(
                  itemCount: serviceHistory.length,
                  itemBuilder: (context, index) {
                    final service = serviceHistory[index];
                    final statusColor = service['status'] == 'Completed' ? Colors.green : Colors.red;

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Service: ${service['service']}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Customer: ${service['customerName']}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Details: ${service['details']}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Time: ${service['time']}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Location: ${service['location']}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Status: ${service['status']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                                Text(
                                  'Cost: ${service['cost']} JD',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
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
