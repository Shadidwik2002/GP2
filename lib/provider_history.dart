import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your API service

class ProviderHistoryPage extends StatefulWidget {
  const ProviderHistoryPage({super.key, required List<Map<String, String>> serviceHistory});

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
    try {
      final response = await apiService.get('/api/ProviderDashboard/bookings?providerId=123'); // Replace with actual providerId
      if (response != null && response is List) {
        setState(() {
          serviceHistory = List<Map<String, String>>.from(response.map((item) {
            return {
              'id': item['id'].toString(),
              'service': item['service'],
              'customerName': item['customerName'],
              'details': item['details'],
              'time': item['time'],
              'location': item['location'],
              'status': item['status'] ?? 'Pending',
              'cost': item['cost'] ?? '0', // Assuming 'cost' is available in response
            };
          }).where((item) =>
              item['status'] == 'Accepted' || item['status'] == 'Declined')); // Filter for Accepted and Declined requests
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
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: const Text(
          'Service History',
          style: TextStyle(color: Colors.black), // Set text color to black
        ),
        backgroundColor: Colors.white, // Set AppBar background color to white
        elevation: 0, // Remove shadow
        iconTheme: const IconThemeData(color: Colors.black), // Set back button color to black
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : serviceHistory.isEmpty
              ? const Center(
                  child: Text(
                    'No history available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // Set text color to black
                  ),
                )
              : ListView.builder(
                  itemCount: serviceHistory.length,
                  itemBuilder: (context, index) {
                    final service = serviceHistory[index];
                    final statusColor =
                        service['status'] == 'Accepted' ? Colors.green : Colors.red;

                    return Card(
                      color: Colors.white, // Set Card background color to white
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Service: ${service['service']}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // Set text color to black
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Customer: ${service['customerName']}',
                              style: const TextStyle(color: Colors.black), // Set text color to black
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Details: ${service['details']}',
                              style: const TextStyle(color: Colors.black), // Set text color to black
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Time: ${service['time']}',
                              style: const TextStyle(color: Colors.black), // Set text color to black
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Location: ${service['location']}',
                              style: const TextStyle(color: Colors.black), // Set text color to black
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
                                    color: Colors.black, // Set text color to black
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