import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for filtering input
import 'sign_up_screen.dart'; // Import the SignUpScreen
import 'forgot_password_screen.dart';
import 'home_screen.dart'; // Import the ForgotPasswordScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // Track password visibility
  String? _phoneError;
  String? _passwordError;

  @override
  void dispose() {
    // Dispose of controllers
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _phoneError = null;
      _passwordError = null;

      if (_phoneController.text.isEmpty) {
        _phoneError = 'Phone number is required';
      }

      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password is required';
      }
    });
  }

  void _login() {
    _validateFields();

    if (_phoneError == null && _passwordError == null) {
      // Handle successful login here
      // For now, show a success dialog
         Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()));
   
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'ServiceHub',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111518),
                ),
              ),
            ),

            // Image
            Container(
              margin: const EdgeInsets.all(20),
              height: 218,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage('https://cdn.usegalileo.ai/sdxl10/3a093c32-1284-4b6c-a777-1ed4deee4fa6.png'),
                ),
              ),
            ),

            // Welcome message
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111518),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Phone Number Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _phoneController, // Set the controller here
                    keyboardType: TextInputType.phone,
                    maxLength: 10, // Limit input to 10 characters
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Only allow digits
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                      filled: true,
                      fillColor: Color(0xFFF0F2F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Icon(Icons.phone, color: Color(0xFF60778A)), // Changed icon to phone
                    ),
                  ),
                  if (_phoneError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        _phoneError!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                ],
              ),
            ),

            // Password Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _passwordController, // Set the controller here
                    obscureText: !_isPasswordVisible, // Use visibility toggle
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: const Color(0xFFF0F2F5),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xFF60778A),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                          });
                        },
                      ),
                    ),
                  ),
                  if (_passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        _passwordError!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                ],
              ),
            ),

            // Forgot password text
            GestureDetector(
              onTap: () {
                // Navigate to Forgot Password Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Forgot your password?',
                  style: TextStyle(
                    color: Color(0xFF60778A),
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            // Log In button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _login, // Call the login function
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFF2094F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // Don't have an account text
            GestureDetector(
              onTap: () {
                // Navigate to Sign Up Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(
                    color: Color(0xFF60778A),
                    fontSize: 14,
                    decoration: TextDecoration.underline, // Optional underline
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
