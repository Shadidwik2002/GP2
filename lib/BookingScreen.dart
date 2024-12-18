import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  final String serviceTitle;

  const BookingScreen({Key? key, required this.serviceTitle}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String? _selectedProvider;

  // Sample data for available providers
  List<Map<String, String>> providers = [
    {"name": "Provider 1", "rating": "4.5", "responseTime": "30 min"},
    {"name": "Provider 2", "rating": "4.7", "responseTime": "20 min"},
    {"name": "Provider 3", "rating": "4.2", "responseTime": "45 min"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment for ${widget.serviceTitle}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Describe the Issue',
                hintText: 'Enter issue description...',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Select Date',
                hintText: 'Enter date for appointment',
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateController.text = pickedDate.toLocal().toString().split(' ')[0];
                  });
                }
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Select Time',
                hintText: 'Enter time for appointment',
              ),
              readOnly: true,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _timeController.text = pickedTime.format(context);
                  });
                }
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedProvider,
              hint: Text('Select Service Provider'),
              items: providers.map((provider) {
                return DropdownMenuItem<String>(
                  value: provider['name'],
                  child: Text('${provider['name']} - Rating: ${provider['rating']}'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedProvider = newValue;
                });
              },
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_descriptionController.text.isNotEmpty &&
                    _dateController.text.isNotEmpty &&
                    _timeController.text.isNotEmpty &&
                    _selectedProvider != null) {
                  // Handle booking confirmation (e.g., show confirmation screen or notification)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Appointment booked successfully!')),
                  );
                } else {
                  // Show error if fields are not filled out
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields.')),
                  );
                }
              },
              child: Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
