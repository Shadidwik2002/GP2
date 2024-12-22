import 'package:flutter/material.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Section Title
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // First Name Field
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  hintText: 'Enter your first name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person, color: Colors.blue),
                ),
                validator: _validateFirstName,
              ),
              const SizedBox(height: 20),

              // Last Name Field
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  hintText: 'Enter your last name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_outline, color: Colors.blue),
                ),
                validator: _validateLastName,
              ),
              const SizedBox(height: 20),

              // Phone Number Field with Verify Button
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.phone, color: Colors.blue),
                      ),
                      validator: _validatePhoneNumber,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_phoneNumberController.text.length == 10) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VerificationScreen(phoneNumber: _phoneNumberController.text),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid phone number.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Verify', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Change Password Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                  );
                },
                icon: const Icon(Icons.lock_outline, color: Colors.white),
                label: const Text('Change Password', style: TextStyle(fontSize: 16,color: Colors.white) ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 30),

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
