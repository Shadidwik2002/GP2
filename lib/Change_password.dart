import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your API service
import 'user_data.dart'; // Import UserData singleton

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _confirmPasswordError;

  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final ApiService apiService = ApiService(baseUrl: 'https://your-api-url.com'); // Initialize your API service

  void _validateNewPassword(String password) {
    setState(() {
      hasMinLength = password.length >= 8;
      hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
      hasLowercase = RegExp(r'[a-z]').hasMatch(password);
      hasNumber = RegExp(r'[0-9]').hasMatch(password);
      hasSpecialChar = RegExp(r'[!@#\$&*~]').hasMatch(password);
    });
  }

  Future<void> _resetPassword() async {
    final phoneNumber = UserData().phoneNumber; // Fetch phoneNumber from UserData

    if (phoneNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Phone number not available.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await apiService.post('/api/Account/reset-password', {
        'identifier': phoneNumber, // Use the phone number dynamically
        'newPassword': _newPasswordController.text,
      });

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Navigate back on success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update password. Please try again.'),
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

  void _validateAndSubmit() {
    setState(() {
      _confirmPasswordError = null;

      if (_confirmPasswordController.text != _newPasswordController.text) {
        _confirmPasswordError = 'Confirm password must match the new password.';
      }

      if (_confirmPasswordError == null &&
          hasMinLength &&
          hasUppercase &&
          hasLowercase &&
          hasNumber &&
          hasSpecialChar) {
        _resetPassword();
      }
    });
  }

  Widget _buildConstraint(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.red,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // New Password Field
            const Text(
              'New Password',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _newPasswordController,
              obscureText: !_isNewPasswordVisible,
              onChanged: _validateNewPassword,
              decoration: InputDecoration(
                hintText: 'Enter new password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.vpn_key, color: Colors.blue),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Password Constraints
            _buildConstraint('At least 8 characters', hasMinLength),
            _buildConstraint('At least 1 uppercase letter', hasUppercase),
            _buildConstraint('At least 1 lowercase letter', hasLowercase),
            _buildConstraint('At least 1 number', hasNumber),
            _buildConstraint('At least 1 special character (!@#\$&*~)', hasSpecialChar),

            const SizedBox(height: 20),

            // Confirm Password Field
            const Text(
              'Confirm New Password',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Re-enter new password',
                errorText: _confirmPasswordError,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.lock_reset, color: Colors.blue),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Update Password Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _validateAndSubmit,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Update Password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
