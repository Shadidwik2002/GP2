// lib/sign_up_screen.dart

import 'package:flutter/material.dart';
import 'verification_screen.dart'; // Import the VerificationScreen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _phoneError = ''; // To hold warning text for invalid phone number
  String _firstNameError = ''; // To hold warning text for empty first name
  String _lastNameError = ''; // To hold warning text for empty last name
  List<String> _passwordErrors = []; // To hold warning texts for password validation
  String _confirmPasswordError = ''; // To hold warning text for empty confirm password
  bool _isPasswordVisible = false; // Track password visibility
  bool _isConfirmPasswordVisible = false; // Track confirm password visibility

  @override
  void dispose() {
    // Dispose of controllers
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      // Clear all errors before validation
      _phoneError = '';
      _firstNameError = '';
      _lastNameError = '';
      _passwordErrors.clear(); // Clear previous password errors
      _confirmPasswordError = '';

      // Check if each field is filled
      if (_firstNameController.text.isEmpty) {
        _firstNameError = 'Please enter your first name';
      }
      if (_lastNameController.text.isEmpty) {
        _lastNameError = 'Please enter your last name';
      }
      // Check for valid phone number (exactly 10 digits)
      String phoneText = _phoneController.text;
      if (phoneText.isEmpty || !_isNumeric(phoneText) || phoneText.length != 10) {
        _phoneError = 'Please enter a valid phone number';
      }
      if (_passwordController.text.isEmpty) {
        _passwordErrors.add('Please enter a password');
      } else {
        // Validate password against new criteria
        String password = _passwordController.text;
        if (password.length < 5) {
          _passwordErrors.add('Password must be at least 5 characters long');
        }
        if (!RegExp(r'[A-Z]').hasMatch(password)) {
          _passwordErrors.add('Password must contain at least one capital letter');
        }
        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
          _passwordErrors.add('Password must contain at least one special character');
        }
      }
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      }

      // Validate passwords only if both fields are filled
      if (_passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty) {
        if (_passwordController.text != _confirmPasswordController.text) {
          _passwordErrors.add('Passwords do not match!');
          _confirmPasswordError = 'Passwords do not match!'; // Add error to confirm password
        }
      }
    });
  }

  void _validateAndContinue() {
    // Validate all inputs before navigating
    _validateInputs();

    // Check if there are any errors
    if (_phoneError.isEmpty &&
        _firstNameError.isEmpty &&
        _lastNameError.isEmpty &&
        _passwordErrors.isEmpty &&
        _confirmPasswordError.isEmpty) {
      // If everything is valid, navigate to the verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            phoneNumber: _phoneController.text, // Pass the phone number
          ),
        ),
      );
    }
  }

  bool _isNumeric(String str) {
    // Check if the string contains only digits
    return RegExp(r'^[0-9]+$').hasMatch(str);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color(0xFF2094F3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // First Name Field
            _buildTextField('First Name', _firstNameController, Icons.person, _firstNameError),
            const SizedBox(height: 15),

            // Last Name Field
            _buildTextField('Last Name', _lastNameController, Icons.person, _lastNameError),
            const SizedBox(height: 15),

            // Phone Number Field
            _buildTextField(
              'Phone Number',
              _phoneController,
              Icons.phone,
              _phoneError,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),

            // Password Field
            _buildPasswordField('Password', _passwordController, _passwordErrors),
            const SizedBox(height: 15),

            // Confirm Password Field
            _buildPasswordField('Confirm Password', _confirmPasswordController, [], isConfirmPassword: true), // No errors for confirm password
            const SizedBox(height: 20),

            // Continue button
            ElevatedButton(
              onPressed: () {
                _validateAndContinue();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF2094F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5, // Add elevation for a shadow effect
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set text color to white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build text fields with icons and error messages
  Widget _buildTextField(String hintText, TextEditingController controller, IconData icon, String errorMessage, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000), // Light shadow
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller, // Set the controller here
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: const Color(0xFFF0F2F5), // Set the background color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF60778A)), // Add the icon
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2094F3), width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          ),
        ),
        // Display error message if any
        if (errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }

  // Helper method to build password fields with visibility tracking and error messages
  Widget _buildPasswordField(String hintText, TextEditingController controller, List<String> errorMessages, {bool isConfirmPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000), // Light shadow
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller, // Set the controller here
            obscureText: isConfirmPassword ? !_isConfirmPasswordVisible : !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: const Color(0xFFF0F2F5), // Set the background color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.lock, color: Color(0xFF60778A)), // Add the icon
              suffixIcon: IconButton(
                icon: Icon(
                  isConfirmPassword ? (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off) : (_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  color: const Color(0xFF60778A),
                ),
                onPressed: () {
                  setState(() {
                    if (isConfirmPassword) {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible; // Toggle confirm password visibility
                    } else {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                    }
                  });
                },
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2094F3), width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          ),
        ),
        // Display error messages if any
        if (errorMessages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: errorMessages.map((msg) {
                return Text(
                  msg,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                );
              }).toList(),
            ),
          ),
        if (isConfirmPassword && _confirmPasswordError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              _confirmPasswordError,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
