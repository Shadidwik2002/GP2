import 'package:flutter/material.dart';
import 'BookingScreen.dart';
import 'home_screen.dart';
import 'api_service.dart';

class ProviderList extends StatefulWidget {
  final Function(Appointment) onAppointmentBooked;
  final int serviceId; // Service ID passed from the previous page

  const ProviderList({
    required this.onAppointmentBooked,
    required this.serviceId,
    super.key,
  });

  @override
  _ProviderListState createState() => _ProviderListState();
}

class _ProviderListState extends State<ProviderList> {
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5196');
  List<Map<String, dynamic>> _providers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProviders();
  }

  Future<void> _fetchProviders() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Fetch providers using the serviceId
      final response = await apiService.get('/api/Service/${widget.serviceId}/providers');
      if (response is List) {
        setState(() {
          _providers = response.map((provider) {
            return {
              'id': provider['id'],
              'name': provider['name'], // Only store the name for display here
              // Store all details to pass to the next screen
              'role': provider['aboutMe'],
              'rating': provider['averageRating'] ?? 0.0,
              'availability': provider['availabilityStatus'],
              'description': provider['aboutMe'], // Assuming aboutMe acts as description
            };
          }).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching providers: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Service Providers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _providers.isEmpty
              ? const Center(child: Text('No providers found'))
              : ListView.builder(
                  itemCount: _providers.length,
                  itemBuilder: (context, index) {
                    final provider = _providers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProviderDetailsPage(
                                providerDetails: provider, // Pass the full details to the next screen
                                serviceId: widget.serviceId,
                                onAppointmentBooked: widget.onAppointmentBooked,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(
                            provider['name'], // Only display the provider's name here
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class ProviderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> providerDetails; // Receive all details as a map
  final int serviceId;
  final Function(Appointment) onAppointmentBooked;

  const ProviderDetailsPage({
    required this.providerDetails,
    required this.serviceId,
    required this.onAppointmentBooked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Provider profile picture and name
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    providerDetails['name'] ?? 'Unknown',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    providerDetails['role'] ?? 'No role specified',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // About section
            const Text(
              'About',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              providerDetails['description'] ?? 'No description available',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Rating
            const Text(
              'Rating',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < (providerDetails['rating'] ?? 0).toInt()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.yellow[700],
                  ),
                ),
                const SizedBox(width: 10),
                Text('(${providerDetails['rating']?.toStringAsFixed(1) ?? '0.0'} rating)'),
              ],
            ),
            const SizedBox(height: 30),

            // Book appointment button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(
                        providerName: providerDetails['name'] ?? 'Unknown',
                        providerId: providerDetails['id'],
                        serviceId: serviceId,
                        onBooked: onAppointmentBooked,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
