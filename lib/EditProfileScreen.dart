import 'package:flutter/material.dart';
// Import the ForgotPasswordScreen
import 'verification_screen.dart'; // Import the VerificationScreen
import 'Change_password.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _firstNameError;
  String? _lastNameError;
  String? _phoneNumberError;

  // Validation logic for first name
  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty || value.length < 3 || !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'First Name must be at least 3 letters and only contain alphabets.';
    }
    return null;
  }

  // Validation logic for last name
  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty || value.length < 3 || !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Last Name must be at least 3 letters and only contain alphabets.';
    }
    return null;
  }

  // Validation logic for phone number
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty || value.length != 10 || !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Phone Number must be 10 digits.';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle successful form submission, like updating user profile
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Name
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
                validator: _validateFirstName,
              ),
              if (_firstNameError != null)
                Text(
                  _firstNameError!,
                  style: const TextStyle(color: Colors.red),
                ),

              // Last Name
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
                validator: _validateLastName,
              ),
              if (_lastNameError != null)
                Text(
                  _lastNameError!,
                  style: const TextStyle(color: Colors.red),
                ),

              // Phone Number and Verify Button
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                      validator: _validatePhoneNumber,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Pass the phone number entered in the controller to the VerificationScreen
                      String phoneNumber = _phoneNumberController.text;
                      if (phoneNumber.isNotEmpty && phoneNumber.length == 10) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerificationScreen(phoneNumber: phoneNumber),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid phone number.')),
                        );
                      }
                    },
                    child: const Text('Verify'),
                  ),
                ],
              ),
              if (_phoneNumberError != null)
                Text(
                  _phoneNumberError!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 16),

              // Password Button (navigate to ForgotPasswordScreen)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  ChangePasswordScreen()),
                  );
                },
                child: const Text('Change Password'),
              ),

              const SizedBox(height: 24),

              // Save button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
