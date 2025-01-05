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
          title: const Text(
            'Thank You!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'We appreciate your feedback!!!!!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFF1980E6), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Rate John',
          style: TextStyle(
            color: Color(0xFF111418),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111418)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Title
            const Text(
              'How would you rate John?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111418),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your feedback helps us improve our service.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Rating Stars and Counter
            Column(
              children: [
                Text(
                  '$_selectedRating',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1980E6),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRating = index + 1;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 40,
                        color: index < _selectedRating
                            ? const Color(0xFF1980E6)
                            : const Color(0xFFE0E0E0),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                const Text(
                  '1 Review',
                  style: TextStyle(fontSize: 14, color: Color(0xFF637588)),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Rating Distribution Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          '${5 - index}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF111418),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: index == 0 ? 1.0 : 0.0,
                            backgroundColor: const Color(0xFFE0E0E0),
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(Color(0xFF1980E6)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${index == 0 ? 100 : 0}%',
                          style: const TextStyle(fontSize: 14, color: Color(0xFF637588)),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 30),

            // Review Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Review',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111418),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Write your review here...',
                      hintStyle: const TextStyle(color: Color(0xFF9FA6B2)),
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
            const SizedBox(height: 20),

            // Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _showThankYouDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1980E6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
