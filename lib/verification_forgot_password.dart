import 'package:flutter/material.dart';
import 'new_password_screen.dart'; // Import the new password screen
import 'api_service.dart'; // Import your ApiService class

class VerificationForgotPassword extends StatefulWidget {
  final String phoneNumber; // Accept the phone number as a parameter

  const VerificationForgotPassword({super.key, required this.phoneNumber});

  @override
  _VerificationForgotPasswordState createState() =>
      _VerificationForgotPasswordState();
}

class _VerificationForgotPasswordState
    extends State<VerificationForgotPassword> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController()); // Updated to 6 digits
  String? warningMessage;
  bool isLoading = false; // To track loading state

  final ApiService apiService =
      ApiService(baseUrl: 'https://your-api-url.com'); // Replace with your base URL

  Future<void> _verifyCode() async {
    // Extract the code from the controllers
    String enteredCode = _controllers.map((controller) => controller.text).join();

    if (enteredCode.isEmpty || enteredCode.length != 6) {
      setState(() {
        warningMessage = 'Please enter a valid 6-digit code.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      warningMessage = null;
    });

    try {
      // Call the API using ApiService
      final response = await apiService.post(
        '/api/Account/verify-code',
        {'phoneNumber': widget.phoneNumber, 'code': enteredCode},
      );

      // Handle success response
      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewPasswordScreen(phoneNumber: widget.phoneNumber),
          ),
        );
      }
    } catch (e) {
      // Handle error
      setState(() {
        warningMessage = 'Verification failed. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mask the phone number to display only the last 4 digits
    String maskedPhoneNumber = widget.phoneNumber.length > 4
        ? '${'*' * (widget.phoneNumber.length - 4)}${widget.phoneNumber.substring(widget.phoneNumber.length - 4)}'
        : widget.phoneNumber;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Your Number',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2094F3),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Section
              Image.asset(
                'images/letter.png', // Replace with your image URL
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),

              // Heading and Description
              const Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please enter the 6-digit code sent to \n$maskedPhoneNumber',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Code Input Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50, // Adjusted width for better spacing with 6 digits
                    child: TextFormField(
                      controller: _controllers[index],
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF2094F3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      buildCounter: (_, {int currentLength = 0, int? maxLength, bool? isFocused}) =>
                          const SizedBox.shrink(),
                    ),
                  );
                }),
              ),

              // Warning Message
              const SizedBox(height: 10),
              if (warningMessage != null)
                Text(
                  warningMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),

              const SizedBox(height: 20),

              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2094F3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Verify',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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
