import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your API service
import 'home_screen.dart'; // Import Appointment class

class RescheduleScreen extends StatefulWidget {
  final Appointment appointment;

  const RescheduleScreen({super.key, required this.appointment});

  @override
  _RescheduleScreenState createState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends State<RescheduleScreen> {
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5196');
  final TextEditingController _dateController = TextEditingController();
  String? _selectedTimeSlot;

  List<String> _availableTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _generateTimeSlots();
  }

  // Generate time slots from 9:00 AM to 5:00 PM (1-hour intervals)
  void _generateTimeSlots() {
    _availableTimeSlots = List.generate(9, (index) {
      int hour = 9 + index;
      String period = hour < 12 ? "AM" : "PM";
      int hourIn12Format = hour > 12 ? hour - 12 : hour;
      return "$hourIn12Format:00 $period";
    });
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _confirmRescheduling() async {
    if (_dateController.text.isNotEmpty && _selectedTimeSlot != null) {
      String newAppointmentDate = "${_dateController.text} ${_selectedTimeSlot}:00";

      try {
        // Send the bookingId and new date/time to the API
        final response = await apiService.post('/api/UserDashboard/reschedule', {
          'bookingId': widget.appointment.id, // Use the bookingId from the appointment
          'newAppointmentDate': newAppointmentDate,
        });

        if (response != null) {
          Navigator.pop(context, {
            'date': _dateController.text,
            'time': _selectedTimeSlot,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking rescheduled successfully!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error rescheduling booking: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time slot.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reschedule Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Select Date',
              ),
              readOnly: true,
              onTap: _selectDate,
            ),
            const SizedBox(height: 20),
            const Text('Select Time Slot'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _availableTimeSlots.map((slot) {
                return ChoiceChip(
                  label: Text(slot),
                  selected: _selectedTimeSlot == slot,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTimeSlot = selected ? slot : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmRescheduling,
              child: const Text('Confirm Reschedule'),
            ),
          ],
        ),
      ),
    );
  }
}
