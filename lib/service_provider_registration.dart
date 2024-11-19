// lib/service_provider_registration.dart

import 'package:flutter/material.dart';

class ServiceProviderRegistration extends StatefulWidget {
  const ServiceProviderRegistration({super.key});

  @override
  _ServiceProviderRegistrationState createState() =>
      _ServiceProviderRegistrationState();
}

class _ServiceProviderRegistrationState
    extends State<ServiceProviderRegistration> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _businessAddressController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _phoneError = '';
  String _emailError = '';
  String _licenseError = '';
  String _addressError = '';
  String _confirmPasswordError = '';
  final List<String> _passwordErrors = [];
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _serviceTypeController.dispose();
    _licenseNumberController.dispose();
    _businessAddressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _phoneError = '';
      _emailError = '';
      _licenseError = '';
      _addressError = '';
      _passwordErrors.clear();
      _confirmPasswordError = '';

      // Phone validation
      String phoneText = _phoneController.text;
      if (phoneText.isEmpty || phoneText.length != 10) {
        _phoneError = 'Please enter a valid phone number';
      }

      // Email validation
      String emailText = _emailController.text;
      if (emailText.isEmpty || !emailText.contains('@')) {
        _emailError = 'Please enter a valid email address';
      }

      // License validation
      if (_licenseNumberController.text.isEmpty) {
        _licenseError = 'Please enter your business license number';
      }

      // Address validation
      if (_businessAddressController.text.isEmpty) {
        _addressError = 'Please enter your business address';
      }

      // Password validation
      if (_passwordController.text.isEmpty) {
        _passwordErrors.add('Please enter a password');
      } else {
        String password = _passwordController.text;
        if (password.length < 8) {
          _passwordErrors.add('At least 8 characters');
        }
        if (!RegExp(r'[A-Z]').hasMatch(password)) {
          _passwordErrors.add('At least one uppercase letter');
        }
        if (!RegExp(r'[a-z]').hasMatch(password)) {
          _passwordErrors.add('At least one lowercase letter');
        }
        if (!RegExp(r'[0-9]').hasMatch(password)) {
          _passwordErrors.add('At least one number');
        }
        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
          _passwordErrors.add('At least one special character');
        }
      }

      // Confirm Password validation
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (_passwordController.text !=
          _confirmPasswordController.text) {
        _confirmPasswordError = 'Passwords do not match!';
      }
    });
  }

  void _submitRegistration() {
    _validateInputs();

    if (_phoneError.isEmpty &&
        _emailError.isEmpty &&
        _licenseError.isEmpty &&
        _addressError.isEmpty &&
        _passwordErrors.isEmpty &&
        _confirmPasswordError.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text('Your application is under review.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Provider Registration'),
        backgroundColor: const Color(0xFF2094F3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Register Account',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTextField('Business Name', _businessNameController),
            const SizedBox(height: 15),
            _buildTextField('Contact Person', _contactPersonController),
            const SizedBox(height: 15),
            _buildTextField(
              'Phone Number',
              _phoneController,
              errorMessage: _phoneError,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              'Email Address',
              _emailController,
              errorMessage: _emailError,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            _buildTextField('Service Type', _serviceTypeController),
            const SizedBox(height: 15),
            _buildTextField(
              'Business License Number',
              _licenseNumberController,
              errorMessage: _licenseError,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              'Business Address',
              _businessAddressController,
              errorMessage: _addressError,
            ),
            const SizedBox(height: 15),
            _buildPasswordField('Password', _passwordController, _passwordErrors),
            const SizedBox(height: 15),
            _buildPasswordField(
              'Confirm Password',
              _confirmPasswordController,
              [],
              isConfirmPassword: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitRegistration,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF2094F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Submit Registration',
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

  Widget _buildTextField(
    String hintText,
    TextEditingController controller, {
    String errorMessage = '',
    TextInputType keyboardType = TextInputType.text,
  }) {
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
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: const Color(0xFFF0F2F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
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

 Widget _buildPasswordField(
  String hintText,
  TextEditingController controller,
  List<String> errorMessages, {
  bool isConfirmPassword = false,
}) {
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
              setState(() {});
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: const Color(0xFFF0F2F5),
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmPassword
                    ? (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off)
                    : (_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
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
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Password must contain:",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                "• At least 8 characters",
                style: TextStyle(
                  color: _passwordController.text.length >= 8 ? Colors.green : Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                "• At least one uppercase letter",
                style: TextStyle(
                  color: RegExp(r'[A-Z]').hasMatch(_passwordController.text)
                      ? Colors.green
                      : Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                "• At least one lowercase letter",
                style: TextStyle(
                  color: RegExp(r'[a-z]').hasMatch(_passwordController.text)
                      ? Colors.green
                      : Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                "• At least one number",
                style: TextStyle(
                  color: RegExp(r'[0-9]').hasMatch(_passwordController.text)
                      ? Colors.green
                      : Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                "• At least one special character",
                style: TextStyle(
                  color: RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_passwordController.text)
                      ? Colors.green
                      : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
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