import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import LatLng
import 'EditProfileScreen.dart';
import 'Login_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'payment.dart';
import 'location_screen.dart'; // Import LocationScreen
import 'api_service.dart'; // Import your API service

class AccountPage extends StatefulWidget {
  final List<Appointment> appointments;

  const AccountPage({super.key, required this.appointments});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  LatLng? _lastSavedLocation; // Variable to store the last saved location
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5196'); // Replace with backend URL
  String userName = "Fetching name..."; // Default placeholder for user name
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Fetch user profile on initialization
  }

  Future<void> _fetchUserProfile() async {
    try {
      final response = await apiService.get('/api/UserDashboard/profile?userId=123'); // Adjust `userId` dynamically
      if (response != null && response['name'] != null) {
        setState(() {
          userName = response['name']; // Fetch the user name
        });
      } else {
        setState(() {
          userName = "Unknown User";
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user profile: $e')),
      );
      setState(() {
        userName = "Error fetching name";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Section
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/profile.png'), // Static profile image for all users
                ),
                const SizedBox(height: 8),
                isLoading
                    ? const CircularProgressIndicator() // Loading spinner while fetching data
                    : Text(
                        userName, // Display dynamic user name
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
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
                  builder: (context) =>
                      HistoryScreen(appointments: widget.appointments),
                ),
              );
            },
          ),

          // Payment Button
          ListTile(
            leading: const Icon(Icons.payment, color: Colors.black),
            title: const Text('Payments'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentScreen(), // Navigate to PaymentScreen
                ),
              );
            },
          ),

          // Location Button
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.black),
            title: const Text('Location'),
            onTap: () async {
              final LatLng? selectedLocation = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationScreen(
                    initialLocation: _lastSavedLocation ?? const LatLng(31.9539, 35.9106), // Default to Amman
                  ),
                ),
              );

              if (selectedLocation != null) {
                setState(() {
                  _lastSavedLocation = selectedLocation; // Update the last saved location
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Location saved: ${_lastSavedLocation!.latitude}, ${_lastSavedLocation!.longitude}',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),

          // Sign Out Button
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text('Sign Out'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
