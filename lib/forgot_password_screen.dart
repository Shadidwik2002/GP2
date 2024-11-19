// lib/forgot_password_screen.dart

import 'package:flutter/material.dart';
import 'verification_forgot_password.dart'; // Import the VerifyNumberScreen

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController phoneController = TextEditingController();
  String? warningMessage;

  void _validatePhoneNumber() {
    setState(() {
      if (phoneController.text.length != 10) {
        warningMessage = 'Please enter a valid 10-digit phone number.';
      } else {
        warningMessage = null;
        // Navigate to VerifyNumberScreen when the phone number is valid
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VerificationForgotPassword()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: const Color(0xFF2094F3),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  'images/padlock.png', // Replace with your image URL
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const Text(
                'Please enter your phone number to receive a verification code.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  hintText: 'Phone number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 10, // Set max length to 10 digits
              ),
              if (warningMessage != null) ...[
                const SizedBox(height: 5),
                Text(
                  warningMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validatePhoneNumber, // Call validation function
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF2094F3),
                ),
                child: const Text(
                  'Send',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
