import 'package:flutter/material.dart';

class ProviderSchedulePage extends StatelessWidget {
  final List<Map<String, String>> acceptedRequests;

  const ProviderSchedulePage({super.key, required this.acceptedRequests});

  @override
  Widget build(BuildContext context) {
    return acceptedRequests.isEmpty
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
          );
  }
}