import 'package:flutter/material.dart';
import 'admin_manage_accounts.dart';
import 'admin_provider_approval.dart';
import 'login_screen.dart';
import 'api_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5196');
  List<Map<String, dynamic>> _services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await apiService.get('/api/AdminDashboard/services');
      if (response is List) {
        setState(() {
          _services = response.map((service) {
            return {
              'id': service['id'],
              'name': service['name'],
              'price': '${service['price']} JD',
              'description': service['description'],
            };
          }).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching services: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _signOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(), // Navigate to LoginScreen
                ),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: _services
                            .asMap()
                            .entries
                            .map(
                              (entry) => DataRow(cells: [
                                DataCell(Text(entry.value['id'].toString())),
                                DataCell(Text(entry.value['name'])),
                                DataCell(Text(entry.value['price'])),
                                DataCell(Text(entry.value['description'])),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {},
                                    ),
                                  ],
                                )),
                              ]),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Add Service (Unavailable)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      const ManageAccountsPage(), // Manage Accounts Page
      const AdminProviderApproval(), // Admin Provider Approval Page
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _currentIndex == 0
              ? 'Manage Services'
              : _currentIndex == 1
                  ? 'Manage Accounts'
                  : 'Provider Approvals',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.build), // Default icon for Manage Services
            label: 'Manage Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Default icon for Manage Accounts
            label: 'Manage Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle), // Default icon for Provider Approvals
            label: 'Provider Approvals',
          ),
        ],
      ),
    );
  }
}
