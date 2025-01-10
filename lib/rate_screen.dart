import 'package:flutter/material.dart';
import 'api_service.dart';

class RateScreen extends StatefulWidget {
  final int providerId; // Accept the provider ID dynamically

  const RateScreen({super.key, required this.providerId});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  int _selectedRating = 0; // Tracks selected rating from 1 to 5
  bool isLoading = true; // Tracks the loading state
  List<Map<String, dynamic>> feedbackData = []; // Stores feedback data
  final ApiService apiService = ApiService(baseUrl: 'https://your-api-url.com'); // Replace with your API URL

  @override
  void initState() {
    super.initState();
    _fetchFeedbackData(); // Fetch feedback data when the screen initializes
  }

  Future<void> _fetchFeedbackData() async {
    try {
      final response = await apiService.get('/api/UserDashboard/feedback/${widget.providerId}');
      if (response != null && response is List) {
        setState(() {
          feedbackData = List<Map<String, dynamic>>.from(response);
        });
      } else {
        setState(() {
          feedbackData = [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching feedback data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to submit feedback
  Future<void> _submitFeedback() async {
    try {
      final review = {
        "providerId": widget.providerId,
        "rating": _selectedRating,
        "review": "User-generated review text", // Replace with actual user input
      };

      final response = await apiService.post('/api/UserDashboard/submit-feedback', review);
      if (response != null) {
        _showThankYouDialog(); // Show the thank you dialog on success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit feedback. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
            'We appreciate your feedback!',
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
          'Rate Provider',
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Title
                  const Text(
                    'How would you rate this provider?',
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

                  // Rating Stars
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
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Feedback History (If any)
                  feedbackData.isEmpty
                      ? const Text('No feedback available for this provider.')
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: feedbackData.map((feedback) {
                              return ListTile(
                                title: Text(
                                  feedback['review'] ?? 'No review text.',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Rating: ${feedback['rating']}',
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              );
                            }).toList(),
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
                        onPressed: () => _submitFeedback(),
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
