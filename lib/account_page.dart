import 'package:flutter/material.dart';
import 'EditProfileScreen.dart'; // Import the EditProfileScreen
import 'Login_screen.dart'; // Import the Login screen to navigate when signing out

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // No title
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes all back buttons
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info
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
                    // Use TextButton here for Edit Profile
                    TextButton(
                      onPressed: () {
                        // Ensure EditProfileScreen is properly defined and no errors are thrown here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(), // Ensure no const used here
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

              // Account & Settings
              const Text(
                'Account & Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('History'),
                onTap: () {
                  // Add functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Personal'),
                onTap: () {
                  // Add functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Payments'),
                onTap: () {
                  // Add functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Favorites'),
                onTap: () {
                  // Add functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.card_giftcard),
                title: const Text('Promos'),
                onTap: () {
                  // Add functionality here
                },
              ),

              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to LoginScreen
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()), // Correct class name
                      (Route<dynamic> route) => false, // Clear all previous routes
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    minimumSize: const Size(200, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Sign out',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
