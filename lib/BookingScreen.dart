import 'package:flutter/material.dart';
import 'api_service.dart';
import 'home_screen.dart';
import 'user_data.dart';

class BookingScreen extends StatefulWidget {
  final String providerName;
  final int providerId;
  final int serviceId;
  final Function(Appointment) onBooked;

  const BookingScreen({
    required this.providerName,
    required this.providerId,
    required this.serviceId,
    required this.onBooked,
    super.key,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5196');
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String _selectedUrgency = "Normal";
  final List<String> _urgencyLevels = ["Low", "Normal", "High"];

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

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (pickedTime != null) {
      if (pickedTime.hour < 9 || pickedTime.hour >= 17) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a time between 9 AM and 5 PM.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() {
          _timeController.text = pickedTime.format(context);
        });
      }
    }
  }

  Future<void> _confirmBooking() async {
    if (_issueController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _timeController.text.isNotEmpty) {
      try {
        final userId = UserData().id; // Use the userId from UserData
        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: User ID not available.')),
          );
          return;
        }

        final response = await apiService.post('/api/Booking', {
          "serviceId": widget.serviceId,
          "serviceProviderId": widget.providerId,
          "userId": userId,
          "appointmentDate": "${_dateController.text} ${_timeController.text}",
          "issueDescription": _issueController.text,
          "urgencyLevel": _selectedUrgency,
        });

        if (response != null && response.containsKey('id')) {
          widget.onBooked(
            Appointment(
              id: response['id'].toString(), // Use the returned booking ID
              providerName: widget.providerName,
              issueDescription: _issueController.text,
              date: _dateController.text,
              time: _timeController.text,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking confirmed successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error confirming booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book with ${widget.providerName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _issueController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Describe the Issue',
                hintText: 'E.g., Leaky faucet, broken AC, etc.',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.description, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: _selectDate,
              decoration: InputDecoration(
                labelText: 'Select Date',
                hintText: 'Choose a date for your appointment',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon:
                    const Icon(Icons.calendar_today, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _timeController,
              readOnly: true,
              onTap: _selectTime,
              decoration: InputDecoration(
                labelText: 'Select Time',
                hintText: 'Choose a time for your appointment',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.access_time, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedUrgency,
              items: _urgencyLevels
                  .map((level) => DropdownMenuItem<String>(
                        value: level,
                        child: Text(level),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUrgency = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Urgency Level',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.priority_high, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _confirmBooking,
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text(
                  'Confirm Booking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
