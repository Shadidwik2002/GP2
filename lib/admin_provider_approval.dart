import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your API service

class AdminProviderApproval extends StatefulWidget {
  const AdminProviderApproval({super.key});

  @override
  _AdminProviderApprovalState createState() => _AdminProviderApprovalState();
}

class _AdminProviderApprovalState extends State<AdminProviderApproval> {
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5196'); // Update your backend URL
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
      final response = await apiService.get('/api/AdminDashboard/users?page=1&pageSize=50');
      if (response is List) {
        setState(() {
          // Filter only "Service Providers" with Pending status
          _providers = response
              .where((user) => user['role'] == 'Service Provider' && user['status'] == 'Pending')
              .map((user) => {
                    'id': user['id'],
                    'name': user['name'] ?? 'No Name',
                    'phone': user['phone'] ?? 'N/A',
                    'serviceCategory': user['serviceCategory'] ?? 'N/A',
                    'status': user['status'],
                  })
              .toList();
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

  Future<void> _updateProviderStatus(String providerId, String status) async {
    try {
      final endpoint = status == 'Approved' ? '/api/Admin/approve/$providerId' : '/api/Admin/reject/$providerId';
      await apiService.post(endpoint, {});

      setState(() {
        _providers.removeWhere((provider) => provider['id'] == providerId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Provider status updated to $status.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating provider status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _providers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.group_off, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No pending providers found',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _providers.length,
                  itemBuilder: (context, index) {
                    final provider = _providers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          provider['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Phone: ${provider['phone']}'),
                            Text('Service Category: ${provider['serviceCategory']}'),
                            const SizedBox(height: 8),
                            Text(
                              'Status: ${provider['status']}',
                              style: TextStyle(
                                color: provider['status'] == 'Pending'
                                    ? Colors.orange
                                    : provider['status'] == 'Approved'
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'Approve') {
                              _updateProviderStatus(provider['id'], 'Approved');
                            } else if (value == 'Decline') {
                              _updateProviderStatus(provider['id'], 'Declined');
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'Approve', child: Text('Approve')),
                            const PopupMenuItem(value: 'Decline', child: Text('Decline')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
