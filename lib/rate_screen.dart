// lib/rate_screen.dart

import 'package:flutter/material.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  int _selectedRating = 0; // Tracks selected rating from 1 to 5

  // Function to show thank you dialog
  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank You!'),
          content: const Text('Thank you for your feedback!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rate John',
          style: TextStyle(
            color: Color(0xFF111418),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: -0.015,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111418)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'How would you rate John?',
              style: TextStyle(
                color: Color(0xFF111418),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.015,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      '$_selectedRating',
                      style: const TextStyle(
                        color: Color(0xFF111418),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            Icons.star,
                            color: index < _selectedRating
                                ? const Color(0xFF111418)
                                : const Color(0xFFdce0e5),
                            size: 24,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedRating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    const Text(
                      '1 review',
                      style: TextStyle(
                        color: Color(0xFF111418),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Text(
                              '${5 - index}',
                              style: const TextStyle(
                                color: Color(0xFF111418),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFdce0e5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: index == 0 ? 1.0 : 0.0,
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF111418),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${index == 0 ? 100 : 0}%',
                              style: const TextStyle(
                                color: Color(0xFF637588),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Your feedback helps us ensure we're providing the best possible service.",
              style: TextStyle(
                color: Color(0xFF111418),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Review',
                  style: TextStyle(
                    color: Color(0xFF111418),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Write a detailed review',
                    hintStyle: const TextStyle(
                      color: Color(0xFF637588),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF0F2F4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  _showThankYouDialog(); // Show thank you dialog on submit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1980E6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
