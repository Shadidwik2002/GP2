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
        _passwordErrors.add('Please enter a password.');
      } else {
        if (password.length < 8) {
          _passwordErrors.add('Password must be at least 8 characters long.');
        }
        if (!RegExp(r'[A-Z]').hasMatch(password)) {
          _passwordErrors.add('Password must contain at least one uppercase letter.');
        }
        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
          _passwordErrors.add('Password must contain at least one special character.');
        }
      }

      // Confirm password validation
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Please confirm your password.';
      } else if (_confirmPasswordController.text != password) {
        _passwordErrors.add('Passwords do not match.');
        _confirmPasswordError = 'Passwords do not match.';
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
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centered Image
              Center(
                child: Image.asset(
                  'images/shield.png', // Replace with your image path
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // New Password Field
              _buildPasswordField(
                hintText: 'New Password',
                controller: _passwordController,
                errorMessages: _passwordErrors,
                isConfirmPassword: false,
              ),
              const SizedBox(height: 20),

              // Confirm Password Field
              _buildPasswordField(
                hintText: 'Confirm Password',
                controller: _confirmPasswordController,
                errorMessages: const [],
                isConfirmPassword: true,
              ),
              const SizedBox(height: 30),

              // Save Password Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validatePasswordFields,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2094F3),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Save Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildPasswordField({
    required String hintText,
    required TextEditingController controller,
    required List<String> errorMessages,
    required bool isConfirmPassword,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isConfirmPassword ? !_isConfirmPasswordVisible : !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFF0F2F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF60778A)),
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
            ),
          ),
        ),
        if (errorMessages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: errorMessages.map((msg) {
                return Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        msg,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        if (isConfirmPassword && _confirmPasswordError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _confirmPasswordError,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
