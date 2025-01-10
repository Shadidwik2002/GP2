import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'verification_change_number.dart'; // Import your updated screen
import 'Change_password.dart';

class EditProfileScreen extends StatefulWidget {
  final String phoneNumber; // Accept phone number as an argument

  const EditProfileScreen({super.key, required this.phoneNumber});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  late TextEditingController _phoneNumberController; // Use phone number controller
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Color _primaryColor = const Color(0xFF2196F3);

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController(text: widget.phoneNumber); // Initialize with phone number
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty || value.length < 3 || !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'First Name must be at least 3 letters and only contain alphabets.';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty || value.length < 3 || !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Last Name must be at least 3 letters and only contain alphabets.';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty || value.length != 10 || !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Phone Number must be 10 digits.';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully!'),
          backgroundColor: _primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        hint: 'Enter your first name',
                        icon: Icons.person,
                        validator: _validateFirstName,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        hint: 'Enter your last name',
                        icon: Icons.person_outline,
                        validator: _validateLastName,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _phoneNumberController,
                              label: 'Phone Number',
                              hint: 'Enter your phone number',
                              icon: Icons.phone,
                              validator: _validatePhoneNumber,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          _buildVerifyButton(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildChangePasswordButton(),
                const SizedBox(height: 20),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        labelStyle: TextStyle(color: _primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: _primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
        prefixIcon: Icon(icon, color: _primaryColor),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
    );
  }

  Widget _buildVerifyButton() {
    return ElevatedButton(
      onPressed: () {
        if (_phoneNumberController.text.length == 10) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VerificationScreen(phoneNumber: _phoneNumberController.text), // Pass to verification
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please enter a valid phone number.'),
              backgroundColor: Colors.red[400],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
      ),
      child: const Text(
        'Verify',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePasswordScreen(phoneNumber: _phoneNumberController.text),
            ),
          );
        },
        icon: const Icon(Icons.lock_outline, color: Colors.white),
        label: const Text(
          'Change Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _submitForm,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text(
          'Save Changes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
        ),
      ),
    );
  }
}
