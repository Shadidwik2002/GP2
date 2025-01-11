import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your API service
import 'provider_history.dart';
import 'login_screen.dart';
import 'user_data.dart'; // Import the UserData singleton

class ProviderProfilePage extends StatefulWidget {
  final List<Map<String, String>> serviceHistory;

  const ProviderProfilePage({super.key, required this.serviceHistory});

  @override
  _ProviderProfilePageState createState() => _ProviderProfilePageState();
}
//sad
class _ProviderProfilePageState extends State<ProviderProfilePage> {
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5196'); // Update your backend URL

  String providerName = 'Service Provider';
  String aboutText = 'Loading...';
  double averageRating = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProviderProfile();
  }

  Future<void> _fetchProviderProfile() async {
    final providerId = UserData().id; // Fetch providerId from UserData

    if (providerId == null) {
      print('Error: Provider ID is null.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Provider ID not available.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await apiService.get('/api/ProviderDashboard/profile?providerId=$providerId');
      setState(() {
        providerName = response['name'] ?? 'Service Provider';
        aboutText = response['about'] ?? 'No about information available.';
        averageRating = response['rating'] != null ? double.parse(response['rating'].toString()) : 0.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _editAbout(BuildContext context) {
    final TextEditingController aboutController = TextEditingController(text: aboutText);

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
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('images/profile.png'),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            providerName,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        UserData().clearUserData(); // Clear user data on logout
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
            ),
    );
  }
}
