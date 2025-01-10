import 'package:flutter/material.dart';
import 'api_service.dart'; // Import the ApiService
import 'home_screen.dart'; // Import Appointment class

class HistoryScreen extends StatefulWidget {
  final int userId; // Pass the user ID to fetch their history

  const HistoryScreen({super.key, required this.userId});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5196'); // Update with your backend URL
  List<Appointment> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory(); // Fetch history when the screen loads
  }

  Future<void> _fetchHistory() async {
    try {
      final response = await apiService.get('/api/Users/${widget.userId}/history?page=1&pageSize=10');
      if (response is List) {
        setState(() {
          appointments = response.map((item) {
            return Appointment(
              providerName: item['serviceProviderName'] ?? 'Unknown Provider',
              issueDescription: item['serviceName'] ?? 'No description',
              date: item['appointmentDate']?.split('T')?.first ?? 'N/A', // Extract date
              time: item['appointmentDate']?.split('T')?.last ?? 'N/A', // Extract time
            );
          }).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching history: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : appointments.isEmpty
              ? const Center(child: Text('No bookings available'))
              : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      child: ListTile(
                        title: Text(appointment.providerName),
                        subtitle: Text(
                          'Issue: ${appointment.issueDescription}\n'
                          'Date: ${appointment.date} at ${appointment.time}',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}