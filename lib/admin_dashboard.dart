import 'package:flutter/material.dart';
import 'admin_manage_accounts.dart';
import 'login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<Map<String, dynamic>> _services = [
    {'name': 'House Cleaning', 'price': '15 JD', 'description': 'Professional house cleaning services'},
    {'name': 'Plumbing', 'price': '8 JD', 'description': 'Fix leaks and other plumbing issues'},
    {'name': 'Electrical', 'price': '15 JD', 'description': 'Electrical repair and maintenance services'},
    {'name': 'Home devices maintenance', 'price': '10 JD', 'description': 'Maintenance of home devices and appliances'},
  ];

  void _deleteService(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: const Text('Are you sure you want to delete this service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _services.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Service deleted!')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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
      SingleChildScrollView(
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
                          DataCell(Text(entry.value['name'])),
                          DataCell(Text('${entry.value['price']}')),
                          DataCell(Text(entry.value['description'])),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteService(entry.key),
                              ),
                            ],
                          )),
                        ]),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              // Display "(Unavailable)" text in dark grey
              const Center(
                child: Text(
                  'Add Service (Unavailable)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey, // Dark grey font
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const ManageAccountsPage(), // Manage Accounts Page
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_currentIndex == 0 ? 'Manage Services' : 'Manage Accounts'),
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
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/manage_service.png',
              height: 30,
              width: 30,
            ),
            label: 'Manage Services',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/manage_account.png',
              height: 30,
              width: 30,
            ),
            label: 'Manage Accounts',
          ),
        ],
      ),
    );
  }
}
