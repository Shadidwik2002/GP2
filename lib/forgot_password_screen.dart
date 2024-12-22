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
        title: const Text(
          'Forgot Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2094F3),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Section
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  'images/padlock.png', // Replace with your image path
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
              ),

              // Title Section
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please enter your phone number to receive a verification code.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Phone Input Field
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone, color: Color(0xFF2094F3)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF0F2F5),
                  counterText: '',
                ),
                keyboardType: TextInputType.phone,
                maxLength: 10, // Max length for 10 digits
              ),

              if (warningMessage != null) ...[
                const SizedBox(height: 5),
                Text(
                  warningMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],

              const SizedBox(height: 30),

              // Send Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validatePhoneNumber,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF2094F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Send Verification Code',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
