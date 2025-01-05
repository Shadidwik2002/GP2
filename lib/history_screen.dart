import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'reschedule_screen.dart';

class HistoryScreen extends StatelessWidget {
  final List<Appointment> appointments;

  const HistoryScreen({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
        backgroundColor: Colors.blue,
      ),
      body: appointments.isEmpty
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
                    trailing: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RescheduleScreen(appointment: appointment),
                          ),
                        );

                        if (result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Appointment rescheduled to ${result['date']} at ${result['time']}',
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Book Again'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
