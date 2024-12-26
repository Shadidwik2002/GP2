import 'package:flutter/material.dart';
import 'home_screen.dart';

class RescheduleScreen extends StatefulWidget {
  final Appointment appointment;

  const RescheduleScreen({Key? key, required this.appointment}) : super(key: key);

  @override
  _RescheduleScreenState createState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends State<RescheduleScreen> {
  final TextEditingController _dateController = TextEditingController();
  String? _selectedTimeSlot;

  final List<String> _availableTimeSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
  ];

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

  void _confirmRescheduling() {
    if (_dateController.text.isNotEmpty && _selectedTimeSlot != null) {
      Navigator.pop(context, {
        'date': _dateController.text,
        'time': _selectedTimeSlot,
      });
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
