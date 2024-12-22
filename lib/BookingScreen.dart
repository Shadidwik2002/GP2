import 'package:flutter/material.dart';
import 'home_screen.dart';

class BookingScreen extends StatefulWidget {
  final String providerName;
  final Function(Appointment) onBooked;

  const BookingScreen({
    required this.providerName,
    required this.onBooked,
    super.key,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

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
      setState(() {
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  void _confirmBooking() {
    if (_issueController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _timeController.text.isNotEmpty) {
      widget.onBooked(
        Appointment(
          providerName: widget.providerName,
          issueDescription: _issueController.text,
          date: _dateController.text,
          time: _timeController.text,
        ),
      );
      Navigator.pop(context);
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
            // Section Title
            const Text(
              'Appointment Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Issue Description Field
            TextField(
              controller: _issueController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Describe the Issue',
                hintText: 'E.g., Leaky faucet, broken AC, etc.',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.description, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),

            // Date Picker
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: _selectDate,
              decoration: InputDecoration(
                labelText: 'Select Date',
                hintText: 'Choose a date for your appointment',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.calendar_today, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),

            // Time Picker
            TextField(
              controller: _timeController,
              readOnly: true,
              onTap: _selectTime,
              decoration: InputDecoration(
                labelText: 'Select Time',
                hintText: 'Choose a time for your appointment',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.access_time, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 30),

            // Confirm Booking Button
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
