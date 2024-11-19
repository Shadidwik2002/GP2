// lib/new_password_screen.dart

import 'package:flutter/material.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  final List<String> _passwordErrors = [];
  String _confirmPasswordError = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _validatePasswordFields() {
    setState(() {
      _passwordErrors.clear();
      _confirmPasswordError = '';

      // Password validation
      String password = _passwordController.text;
      if (password.isEmpty) {
        _passwordErrors.add('Please enter a password');
      } else {
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

      // Confirm password validation
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (_confirmPasswordController.text != password) {
        _passwordErrors.add('Passwords do not match');
        _confirmPasswordError = 'Passwords do not match';
      }

      // Show success message if no errors
      if (_passwordErrors.isEmpty && _confirmPasswordError.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set New Password'),
        backgroundColor: const Color(0xFF2094F3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'images/shield.png', // Replace with your image path
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            _buildPasswordField('New Password', _passwordController, _passwordErrors),
            const SizedBox(height: 15),
            _buildPasswordField('Confirm Password', _confirmPasswordController, [], isConfirmPassword: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validatePasswordFields,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF2094F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Save Password',
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
                  isConfirmPassword
                      ? (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off)
                      : (_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
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
        if (errorMessages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: errorMessages.map((msg) => Text(
                msg,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              )).toList(),
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
