import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gp2/api_service.dart'; // Replace with your actual ApiService implementation

class ServiceProviderRegistration extends StatefulWidget {
  const ServiceProviderRegistration({super.key});

  @override
  _ServiceProviderRegistrationState createState() =>
      _ServiceProviderRegistrationState();
}

class _ServiceProviderRegistrationState
    extends State<ServiceProviderRegistration> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final List<String> _serviceTypes = [
    'Electrician',
    'Plumber',
    'House Cleaning',
    'Home Device Maintenance'
  ];
  final List<String> _selectedServiceTypes = [];

  final ApiService apiService =
      ApiService(baseUrl: 'http://localhost:5196'); // Replace with your backend URL

  String _firstNameError = '';
  String _lastNameError = '';
  String _phoneError = '';
  String _licenseError = '';
  String _serviceTypeError = '';
  String _confirmPasswordError = '';
  final List<String> _passwordErrors = [];
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isDropdownOpen = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _licenseNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _firstNameError = '';
      _lastNameError = '';
      _phoneError = '';
      _licenseError = '';
      _serviceTypeError = '';
      _passwordErrors.clear();
      _confirmPasswordError = '';

      if (_firstNameController.text.isEmpty) {
        _firstNameError = 'First name cannot be empty';
      }

      if (_lastNameController.text.isEmpty) {
        _lastNameError = 'Last name cannot be empty';
      }

      String phoneText = _phoneController.text;
      if (phoneText.isEmpty || phoneText.length != 10) {
        _phoneError = 'Please enter a valid 10-digit phone number';
      }

      if (_licenseNumberController.text.isEmpty) {
        _licenseError = 'Please enter your business license number';
      }

      if (_selectedServiceTypes.isEmpty) {
        _serviceTypeError = 'Please select at least one service type';
      }

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

      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (_passwordController.text !=
          _confirmPasswordController.text) {
        _confirmPasswordError = 'Passwords do not match!';
      }
    });
  }

  Future<void> _submitRegistration() async {
    _validateInputs();

    if (_firstNameError.isEmpty &&
        _lastNameError.isEmpty &&
        _phoneError.isEmpty &&
        _licenseError.isEmpty &&
        _serviceTypeError.isEmpty &&
        _passwordErrors.isEmpty &&
        _confirmPasswordError.isEmpty) {
      setState(() {
        _isLoading = true;
      });

      final providerRegistrationDto = {
        'name': '${_firstNameController.text} ${_lastNameController.text}',
        'phoneNumber': _phoneController.text,
        'password': _passwordController.text,
        'serviceCategory': _selectedServiceTypes.join(', '),
      };

      try {
        final response = await apiService.post(
          '/api/Admin/register/provider',
          providerRegistrationDto,
        );

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

        print('Registration successful: $response');
      } catch (e) {
        print('Failed to register provider: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registration Failed'),
            content: const Text('An error occurred during registration.'),
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
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildTextField(
    String hintText,
    TextEditingController controller, {
    String errorMessage = '',
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            labelText: hintText,
            filled: true,
            fillColor: const Color(0xFFF0F2F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
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
        TextFormField(
          controller: controller,
          obscureText: isConfirmPassword ? !_isConfirmPasswordVisible : !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: hintText,
            filled: true,
            fillColor: const Color(0xFFF0F2F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmPassword
                    ? (_isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off)
                    : (_isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
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
        if (errorMessages.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: errorMessages.map((e) {
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  e,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              );
            }).toList(),
          ),
      ],
    );
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
            _buildTextField(
              'First Name',
              _firstNameController,
              errorMessage: _firstNameError,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))],
            ),
            const SizedBox(height: 15),
            _buildTextField(
              'Last Name',
              _lastNameController,
              errorMessage: _lastNameError,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))],
            ),
            const SizedBox(height: 15),
            _buildTextField(
              'Phone Number',
              _phoneController,
              errorMessage: _phoneError,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10)
              ],
            ),
            const SizedBox(height: 15),
            _buildTextField(
              'Business License Number',
              _licenseNumberController,
              errorMessage: _licenseError,
            ),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Service Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isDropdownOpen = !_isDropdownOpen;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _serviceTypeError.isNotEmpty
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedServiceTypes.isEmpty
                                ? 'Select Service Types (Required)'
                                : _selectedServiceTypes.join(', '),
                            style: TextStyle(
                              color: _selectedServiceTypes.isEmpty
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Icon(_isDropdownOpen
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                if (_isDropdownOpen)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _serviceTypeError.isNotEmpty
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                    child: Column(
                      children: _serviceTypes.map((type) {
                        return CheckboxListTile(
                          title: Text(type),
                          value: _selectedServiceTypes.contains(type),
                          onChanged: (isSelected) {
                            setState(() {
                              if (isSelected == true) {
                                _selectedServiceTypes.add(type);
                                _serviceTypeError = '';
                              } else {
                                _selectedServiceTypes.remove(type);
                                if (_selectedServiceTypes.isEmpty) {
                                  _serviceTypeError =
                                      'Please select at least one service type';
                                }
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                if (_serviceTypeError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      _serviceTypeError,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            _buildPasswordField('Password', _passwordController, _passwordErrors),
            const SizedBox(height: 15),
            _buildPasswordField(
              'Confirm Password',
              _confirmPasswordController,
              [_confirmPasswordError],
              isConfirmPassword: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
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
}
