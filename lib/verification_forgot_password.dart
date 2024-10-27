// lib/verify_number_screen.dart

import 'package:flutter/material.dart';
import 'new_password_screen.dart'; // Import the new password screen

class VerificationForgotPassword extends StatefulWidget {
  const VerificationForgotPassword({Key? key}) : super(key: key);

  @override
  _VerificationForgotPasswordState createState() => _VerificationForgotPasswordState();
}

class _VerificationForgotPasswordState extends State<VerificationForgotPassword> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  String? warningMessage;

  void _verifyCode() {
    // Extract the code from the controllers
    String enteredCode = _controllers.map((controller) => controller.text).join();

    setState(() {
      if (enteredCode == '1234') {
        warningMessage = null; // Clear warning
        // Navigate to the New Password Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewPasswordScreen()),
        );
      } else {
        warningMessage = 'Invalid code. Please try again.'; // Display warning
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Number'),
        backgroundColor: const Color(0xFF2094F3),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Insert the image here
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  'images/letter.png', // Replace with your image URL
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const Text(
                'Please enter the 4 digit code sent to your number.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Code input boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: _controllers[index],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      buildCounter: (BuildContext context,
                          {int? currentLength, int? maxLength, bool? isFocused}) {
                        return const SizedBox.shrink(); // Hide counter
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 5),
              // Display warning message if the code is incorrect
              if (warningMessage != null)
                Text(
                  warningMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              const SizedBox(height: 20),
              // Resend Code button
              TextButton(
                onPressed: () {
                  // Handle resend code action here
                },
                child: const Text(
                  'Resend Code',
                  style: TextStyle(color: Color(0xFF2094F3)),
                ),
              ),
              const SizedBox(height: 20),
              // Verify button
              ElevatedButton(
                onPressed: _verifyCode,
                child: const Text(
                  'Verify',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF2094F3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
