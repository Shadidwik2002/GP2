import 'package:flutter/material.dart';
import 'BookingScreen.dart';
import 'home_screen.dart'; // Import Appointment class


class ProviderList extends StatelessWidget {
  final Function(Appointment) onAppointmentBooked;

  ProviderList({required this.onAppointmentBooked, super.key});

  final List<Map<String, String>> providers = [
    {'name': 'James Smith', 'role': 'Plumber'},
    {'name': 'Emma Johnson', 'role': 'House Cleaner'},
    {'name': 'Michael Brown', 'role': 'Electrician'},
    {'name': 'Olivia Green', 'role': 'Plumber'},
    {'name': 'Liam Miller', 'role': 'House Cleaner'},
    {'name': 'Sophia Wilson', 'role': 'Plumber'},
    {'name': 'William Moore', 'role': 'House Cleaner'},
    {'name': 'Ava Taylor', 'role': 'Electrician'},
    {'name': 'Isabella Davis', 'role': 'House Cleaner'},
    {'name': 'Mason White', 'role': 'Electrician'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Service Providers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final provider = providers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProviderDetailsPage(
                      providerName: provider['name']!,
                      role: provider['role']!,
                      onAppointmentBooked: onAppointmentBooked,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  // Profile Placeholder Image
                  Container(
                    margin: const EdgeInsets.all(8),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),

                  // Provider Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider['name']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            provider['role']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Arrow Icon
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.arrow_forward_ios, color: Colors.blue),
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

class ProviderDetailsPage extends StatelessWidget {
  final String providerName;
  final String role;
  final Function(Appointment) onAppointmentBooked;

  const ProviderDetailsPage({
    required this.providerName,
    required this.role,
    required this.onAppointmentBooked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image and Basic Info
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    providerName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    role,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // About Section
            const Text(
              'About',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'I have been doing maintenance for the last 3 years. I am a perfectionist and take pride in my work. I am very detail-oriented.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Experience Section
            const Text(
              'Experience',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildExperience('Maintenance Professional', 'TaskRabbit', '2019-2022'),
            const SizedBox(height: 10),
            _buildExperience('Maintenance Professional', 'Handy', '2017-2019'),
            const SizedBox(height: 20),

            // Reviews Section
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildRatingSummary(),
            _buildReview('Sara M', 'Qais is amazing! He is very detail-oriented and fixed my AC.', 'Aug 2022', 5),
            _buildReview('John L', 'She was great and fixed our broken fridge. Very professional.', 'Jul 2022', 5),
            const SizedBox(height: 30),

            // Book Appointment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(
                        providerName: providerName,
                        onBooked: onAppointmentBooked,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Experience Widget
  Widget _buildExperience(String title, String company, String duration) {
    return Row(
      children: [
        const Icon(Icons.work_outline, color: Colors.blue),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                company,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        Text(duration, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  // Rating Summary
  Widget _buildRatingSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '4.8',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            _buildStarRating(4.8),
            const SizedBox(width: 5),
            const Text('230 reviews', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 10),
        _buildRatingBar('5', 77),
        _buildRatingBar('4', 15),
        _buildRatingBar('3', 5),
        _buildRatingBar('2', 2),
        _buildRatingBar('1', 1),
      ],
    );
  }

  Widget _buildRatingBar(String label, int percent) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 5),
        Expanded(
          child: LinearProgressIndicator(
            value: percent / 100,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        const SizedBox(width: 5),
        Text('$percent%'),
      ],
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.yellow[700],
          size: 20,
        ),
      ),
    );
  }

  Widget _buildReview(String name, String comment, String date, int rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 20, backgroundColor: Colors.blue),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(date, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 5),
        _buildStarRating(rating.toDouble()),
        const SizedBox(height: 5),
        Text(comment, style: const TextStyle(fontSize: 14)),
        const Divider(height: 20),
      ],
    );
  }
}
