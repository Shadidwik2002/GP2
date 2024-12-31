import 'package:flutter/material.dart';
import 'EditProfileScreen.dart';
import 'Login_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'payment.dart'; 
import 'location_screen.dart';

class AccountPage extends StatelessWidget {
  final List<Appointment> appointments;

  const AccountPage({super.key, required this.appointments});

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
                      HistoryScreen(appointments: appointments),
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
