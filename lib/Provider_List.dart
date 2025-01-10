// Provider_List.dart

import 'package:flutter/material.dart';
import 'BookingScreen.dart';
import 'home_screen.dart';
import 'api_service.dart';

class ProviderList extends StatefulWidget {
  final Function(Appointment) onAppointmentBooked;
  final int serviceId;

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
      final response = await apiService.get('/api/ProviderDashboard/services');
      if (response is List) {
        setState(() {
          _providers = response.map((provider) {
            return {
              'id': provider['id'],
              'name': provider['name'],
              'role': provider['category'],
              'rating': provider['averageRating'] ?? 0.0,
              'description': provider['description'],
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
                                providerId: provider['id'],
                                providerName: provider['name'],
                                role: provider['role'],
                                serviceId: widget.serviceId,
                                onAppointmentBooked: widget.onAppointmentBooked,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      provider['name'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      provider['role'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(Icons.arrow_forward_ios, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class ProviderDetailsPage extends StatelessWidget {
  final int providerId;
  final String providerName;
  final String role;
  final int serviceId;
  final Function(Appointment) onAppointmentBooked;

  const ProviderDetailsPage({
    required this.providerId,
    required this.providerName,
    required this.role,
    required this.serviceId,
    required this.onAppointmentBooked,
    super.key,
  });

  Future<Map<String, dynamic>> _fetchProviderDetails(int providerId) async {
final apiService = ApiService(baseUrl: 'http://localhost:5196');
    final response = await apiService.get('/api/ProviderDashboard/services/$providerId');
    return response as Map<String, dynamic>;
  }

  Widget _buildRatingSummary(double? averageRating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (averageRating ?? 0).toStringAsFixed(1),
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ...List.generate(
              5,
              (index) => Icon(
                index < (averageRating ?? 0) ? Icons.star : Icons.star_border,
                color: Colors.yellow[700],
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text('(${(averageRating ?? 0).toStringAsFixed(1)} rating)'),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: _fetchProviderDetails(providerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Provider not found'));
          }

          final provider = snapshot.data as Map<String, dynamic>;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        provider['name'] ?? providerName,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        provider['role'] ?? role,
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'About',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  provider['description'] ?? 'No description available',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Reviews',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildRatingSummary(provider['averageRating']),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingScreen(
                            providerName: provider['name'] ?? providerName,
                            providerId: providerId,
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
          );
        },
      ),
    );
  }
}