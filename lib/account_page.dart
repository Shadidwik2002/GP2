import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import LatLng
import 'EditProfileScreen.dart';
import 'Login_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'payment.dart';
import 'location_screen.dart'; // Import LocationScreen

class AccountPage extends StatefulWidget {
  final List<Appointment> appointments;

  const AccountPage({super.key, required this.appointments});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  LatLng? _lastSavedLocation; // Variable to store the last saved location

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
                  backgroundImage: AssetImage('images/profile.png'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'New User',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
