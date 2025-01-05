import 'package:flutter/material.dart';

class ProviderHistoryPage extends StatelessWidget {
  final List<Map<String, String>> serviceHistory;

  const ProviderHistoryPage({super.key, required this.serviceHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service History'),
      ),
      body: serviceHistory.isEmpty
          ? const Center(
              child: Text(
                'No history available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: serviceHistory.length,
              itemBuilder: (context, index) {
                final service = serviceHistory[index];
                final statusColor =
                    service['status'] == 'Accepted' ? Colors.green : Colors.red;

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Service: ${service['service']}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text('Customer: ${service['customerName']}'),
                        const SizedBox(height: 5),
                        Text('Details: ${service['details']}'),
                        const SizedBox(height: 5),
                        Text('Time: ${service['time']}'),
                        const SizedBox(height: 5),
                        Text('Location: ${service['location']}'),
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