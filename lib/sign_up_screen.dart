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
  final List<String> _passwordErrors = []; // To hold warning texts for password validation
  String _confirmPasswordError = ''; // To hold warning text for empty confirm password
  bool _isPasswordVisible = false; // Track password visibility
  bool _isConfirmPasswordVisible = false; // Track confirm password visibility

  @override
  void dispose() {
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _phoneError = '';
      _firstNameError = '';
      _lastNameError = '';
      _passwordErrors.clear();
      _confirmPasswordError = '';

      if (_firstNameController.text.isEmpty) {
        _firstNameError = 'Please enter your first name';
      }
      if (_lastNameController.text.isEmpty) {
        _lastNameError = 'Please enter your last name';
      }

      String phoneText = _phoneController.text;
      if (phoneText.isEmpty || !_isNumeric(phoneText) || phoneText.length != 10) {
        _phoneError = 'Please enter a valid phone number';
      }

      if (_passwordController.text.isEmpty) {
        _passwordErrors.add('Please enter a password');
      } else {
        String password = _passwordController.text;
        if (password.length < 8) {
          _passwordErrors.add('Password must be at least 8 characters long');
        }
        if (!RegExp(r'[A-Z]').hasMatch(password)) {
          _passwordErrors.add('Password must contain at least one uppercase letter');
        }
        if (!RegExp(r'[a-z]').hasMatch(password)) {
          _passwordErrors.add('Password must contain at least one lowercase letter');
        }
        if (!RegExp(r'[0-9]').hasMatch(password)) {
          _passwordErrors.add('Password must contain at least one number');
        }
        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
          _passwordErrors.add('Password must contain at least one special character');
        }
      }

      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      }

      if (_passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty) {
        if (_passwordController.text != _confirmPasswordController.text) {
          _passwordErrors.add('Passwords do not match!');
          _confirmPasswordError = 'Passwords do not match!';
        }
      }
    });
  }

  void _validateAndContinue() {
    _validateInputs();

    if (_phoneError.isEmpty &&
        _firstNameError.isEmpty &&
        _lastNameError.isEmpty &&
        _passwordErrors.isEmpty &&
        _confirmPasswordError.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            phoneNumber: _phoneController.text,
          ),
        ),
      );
    }
  }

  bool _isNumeric(String str) {
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
            _buildTextField('First Name', _firstNameController, Icons.person, _firstNameError),
            const SizedBox(height: 15),
            _buildTextField('Last Name', _lastNameController, Icons.person, _lastNameError),
            const SizedBox(height: 15),
            _buildTextField(
              'Phone Number',
              _phoneController,
              Icons.phone,
              _phoneError,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            _buildPasswordField('Password', _passwordController, _passwordErrors),
            const SizedBox(height: 15),
            _buildPasswordField('Confirm Password', _confirmPasswordController, [], isConfirmPassword: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validateAndContinue,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF2094F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller, IconData icon, String errorMessage, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x29000000),
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: const Color(0xFFF0F2F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF60778A)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2094F3), width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          ),
        ),
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

  Widget _buildPasswordField(String hintText, TextEditingController controller, List<String> errorMessages, {bool isConfirmPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x29000000),
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isConfirmPassword ? !_isConfirmPasswordVisible : !_isPasswordVisible,
            onChanged: (value) {
              if (!isConfirmPassword) {
                setState(() => _validateInputs());
              }
            },
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: const Color(0xFFF0F2F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.lock, color: Color(0xFF60778A)),
              suffixIcon: IconButton(
                icon: Icon(
                  isConfirmPassword ? (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off) : (_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  color: const Color(0xFF60778A),
                ),
                onPressed: () {
                  setState(() {
                    if (isConfirmPassword) {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    } else {
                      _isPasswordVisible = !_isPasswordVisible;
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
        if (!isConfirmPassword)
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPasswordCriteriaItem('At least 8 characters', _passwordController.text.length >= 8),
                _buildPasswordCriteriaItem('At least one uppercase letter', RegExp(r'[A-Z]').hasMatch(_passwordController.text)),
                _buildPasswordCriteriaItem('At least one lowercase letter', RegExp(r'[a-z]').hasMatch(_passwordController.text)),
                _buildPasswordCriteriaItem('At least one number', RegExp(r'[0-9]').hasMatch(_passwordController.text)),
                _buildPasswordCriteriaItem('At least one special character (!@#\$%^&*)', RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_passwordController.text)),
              ],
            ),
          ),
        if (errorMessages.isNotEmpty)
          Column(
            children: errorMessages.map((errorMessage) {
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildPasswordCriteriaItem(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isValid ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }
}
