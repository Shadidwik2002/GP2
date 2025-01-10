import 'package:flutter/material.dart';
import 'provider_history.dart';
import 'login_screen.dart';

class ProviderProfilePage extends StatefulWidget {
  final List<Map<String, String>> serviceHistory;

  const ProviderProfilePage({super.key, required this.serviceHistory});

  @override
  _ProviderProfilePageState createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  String aboutText =
      'I have been doing maintenance for the last 3 years. I am a perfectionist and take pride in my work. I am very detail-oriented.';
  final double averageRating = 4.5; // Example average rating value

  void _editAbout(BuildContext context) {
    final TextEditingController aboutController =
        TextEditingController(text: aboutText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit About'),
          content: TextField(
            controller: aboutController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Enter your about information',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  aboutText = aboutController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('About updated successfully!')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('images/profile.png'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Service Provider',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Average Rating
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 24),
                  const SizedBox(width: 4),
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '(Avg. Rating)',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // About Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'About',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editAbout(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              aboutText,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 24),

            

            // History Button
            ListTile(
              leading: const Icon(Icons.history, color: Colors.black),
              title: const Text('History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProviderHistoryPage(
                      serviceHistory: widget.serviceHistory,
                    ),
                  ),
                );
              },
            ),

            // Sign Out Button
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceTile({
    required String companyName,
    required String role,
    required String years,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.work, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  companyName,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            years,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
