// lib/verification_screen.dart

import 'package:flutter/material.dart';

class VerificationScreen extends StatelessWidget {
  final String phoneNumber;

  const VerificationScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    // Mask the phone number to show only the last 4 digits
    String maskedPhoneNumber = phoneNumber.length > 4
        ? '${'*' * (phoneNumber.length - 4)}${phoneNumber.substring(phoneNumber.length - 4)}'
        : phoneNumber;

    // Create a TextEditingController to collect input from the code fields
    final List<TextEditingController> controllers = List.generate(4, (index) => TextEditingController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Match this to the image's background color
      appBar: AppBar(
        title: const Text('Verification'),
        backgroundColor: const Color(0xFF2094F3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image above the verification code
            Image.asset(
              'images/verify.png', // Local image path
              height: 80, // Set a specific height
              width: 80, // Set a specific width
              fit: BoxFit.contain, // Ensure the image maintains its aspect ratio
            ),
            const SizedBox(height: 20), // Space between image and text

            const Text(
              'Verification Code',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text(
              'Enter the 4-digit code sent to $maskedPhoneNumber',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Input fields for the verification code
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 60,
                  child: TextFormField(
                    controller: controllers[index], // Assign the controller to the field
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: '', // No hint text
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      counterText: '', // Hide the counter text
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1, // Limit to 1 character
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Resend code text
            GestureDetector(
              onTap: () {
                // Logic to resend code
              },
              child: const Text(
                "Didn't get the code? Click to resend",
                style: TextStyle(color: Color(0xFF2094F3)),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons for Cancel and Verify
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cancel button logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5, // Add elevation for a shadow effect
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black), // Set text color to black
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Verify button logic
                    // Check if the entered code matches "1234"
                    String enteredCode = controllers.map((controller) => controller.text).join('');
                    if (enteredCode == '1234') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Verification successful!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid code, please try again.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2094F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5, // Add elevation for a shadow effect
                  ),
                  child: const Text('Verify',
                  style: TextStyle(color: Colors.white),),
                  
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
