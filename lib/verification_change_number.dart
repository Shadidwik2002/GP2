import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your API service

class VerificationScreen extends StatelessWidget {
  final String phoneNumber; // Phone number received from EditProfileScreen
  final ApiService apiService =
      ApiService(baseUrl: 'https://your-api-url.com'); // Replace with actual base URL

  VerificationScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    // Mask the phone number to show only the last 4 digits
    String maskedPhoneNumber = phoneNumber.length > 4
        ? '${'*' * (phoneNumber.length - 4)}${phoneNumber.substring(phoneNumber.length - 4)}'
        : phoneNumber;

    // Controllers for the verification input fields
    final List<TextEditingController> controllers =
        List.generate(6, (index) => TextEditingController());

    Future<void> _verifyCode(String phoneNumber, String code) async {
      try {
        final response = await apiService.post('/api/Account/verify-code', {
          'phoneNumber': phoneNumber,
          'code': code,
        });

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification successful!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Navigate back on success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid verification code. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2094F3),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Verification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // Top Icon
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.verified_outlined,
                size: 70,
                color: Color(0xFF2094F3),
              ),
            ),
            const SizedBox(height: 20),

            // Heading
            const Text(
              'Enter Verification Code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              'We have sent a 6-digit verification code to \n$maskedPhoneNumber',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Input fields for verification code
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 50,
                  height: 60,
                  child: TextFormField(
                    controller: controllers[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFB0BEC5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF2094F3)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate back
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                // Verify Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Combine entered code
                      String enteredCode = controllers
                          .map((controller) => controller.text)
                          .join();

                      if (enteredCode.length == 6) {
                        // Verify the code using the API
                        _verifyCode(phoneNumber, enteredCode);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter all 6 digits.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2094F3),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Verify',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
