import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _emailError = '';
  String _passwordError = '';
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _emailError = '';
      _passwordError = '';

      // Email validation
      String email = _emailController.text.trim();
      if (email.isEmpty || !email.contains('@')) {
        _emailError = 'Please enter a valid email address';
      }

      // Password validation
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Please enter your password';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Admin Login',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2094F3),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Admin Logo/Icon
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.admin_panel_settings,
                  size: 60,
                  color: Color(0xFF2094F3),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Welcome, Admin!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111418),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please login to access your dashboard',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF60778A),
              ),
            ),
            const SizedBox(height: 30),

            // Email TextField
            _buildTextField(
              hintText: 'Email Address',
              controller: _emailController,
              errorMessage: _emailError,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Password TextField
            _buildPasswordField(
              hintText: 'Password',
              controller: _passwordController,
              errorMessage: _passwordError,
            ),
            const SizedBox(height: 10),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigate to Forgot Password screen logic here
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Color(0xFF2094F3), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              onPressed: () {
                _validateInputs();
                // Mock navigation on successful login
                if (_emailError.isEmpty && _passwordError.isEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(
                        child: Center(
                          child: Text(
                            'Admin Dashboard (Replace this page)',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF2094F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Footer
            const Text(
              '© 2024 Admin Panel. All rights reserved.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF60778A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Method: Build TextField
  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required String errorMessage,
    required IconData icon,
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

  // Helper Method: Build PasswordField
  Widget _buildPasswordField({
    required String hintText,
    required TextEditingController controller,
    required String errorMessage,
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
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: const Color(0xFFF0F2F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF60778A)),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF60778A),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
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
}
