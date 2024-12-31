import 'package:flutter/material.dart';

class ManageAccountsPage extends StatefulWidget {
  const ManageAccountsPage({super.key});

  @override
  _ManageAccountsPageState createState() => _ManageAccountsPageState();
}

class _ManageAccountsPageState extends State<ManageAccountsPage> {
  final List<Map<String, String>> _users = [
    {
      'name': 'John Doe',
      'status': 'Active',
      'type': 'User',
      'phone': '1234567890',
      'id': 'U001',
    },
    {
      'name': 'Jane Smith',
      'status': 'Inactive',
      'type': 'Service Provider',
      'phone': '0987654321',
      'id': 'SP002',
      'service': 'Plumber',
    },
    {
      'name': 'Michael Johnson',
      'status': 'Active',
      'type': 'User',
      'phone': '1122334455',
      'id': 'U003',
    },
    {
      'name': 'Emily Davis',
      'status': 'Active',
      'type': 'Service Provider',
      'phone': '2233445566',
      'id': 'SP004',
      'service': 'Electrician',
    },
    {
      'name': 'Sarah Wilson',
      'status': 'Inactive',
      'type': 'User',
      'phone': '3344556677',
      'id': 'U005',
    },
    {
      'name': 'James Brown',
      'status': 'Active',
      'type': 'Service Provider',
      'phone': '4455667788',
      'id': 'SP006',
      'service': 'House Cleaning',
    },
    {
      'name': 'Linda Taylor',
      'status': 'Active',
      'type': 'User',
      'phone': '5566778899',
      'id': 'U007',
    },
    {
      'name': 'David Anderson',
      'status': 'Inactive',
      'type': 'Service Provider',
      'phone': '6677889900',
      'id': 'SP008',
      'service': 'Home Device Maintenance',
    },
    {
      'name': 'Sophia Thomas',
      'status': 'Active',
      'type': 'User',
      'phone': '7788990011',
      'id': 'U009',
    },
    {
      'name': 'Robert Martinez',
      'status': 'Active',
      'type': 'Service Provider',
      'phone': '8899001122',
      'id': 'SP010',
      'service': 'Electrician',
    },
  ];

  String _searchQuery = '';

  void _changeUserStatus(BuildContext context, int index, String newStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${newStatus == 'Inactive' ? 'Deactivate' : 'Activate'} User'),
        content: Text(
          'Are you sure you want to ${newStatus.toLowerCase()} this user?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _users[index]['status'] = newStatus;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'User ${newStatus.toLowerCase()}d successfully!',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: newStatus == 'Inactive' ? Colors.red : Colors.green,
            ),
            child: Text(
              newStatus == 'Inactive' ? 'Deactivate' : 'Activate',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _viewUserDetails(BuildContext context, Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${user['name']}'s Details"),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Type'),
                subtitle: Text(user['type'] ?? ''),
              ),
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: const Text('Phone'),
                subtitle: Text(user['phone'] ?? ''),
              ),
              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: const Text('ID'),
                subtitle: Text(user['id'] ?? ''),
              ),
              if (user['type'] == 'Service Provider')
                ListTile(
                  leading: const Icon(Icons.work_outline),
                  title: const Text('Service'),
                  subtitle: Text(user['service'] ?? 'Not Specified'),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users
        .where((user) =>
            user['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              hintText: 'Search users',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              hintStyle: TextStyle(color: Colors.grey[600]),
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: filteredUsers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No users found',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      user['name'] ?? 'No Name',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: user['status'] == 'Active'
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                user['status'] ?? '',
                                style: TextStyle(
                                  color: user['status'] == 'Active'
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(user['type'] ?? ''),
                          ],
                        ),
                      ],
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        if (user['status'] == 'Active') {
                          _changeUserStatus(context, index, 'Inactive');
                        } else {
                          _changeUserStatus(context, index, 'Active');
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        user['status'] == 'Active' ? 'Deactivate' : 'Activate',
                        style: TextStyle(
                          color: user['status'] == 'Active'
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ),
                    onTap: () => _viewUserDetails(context, user),
                  ),
                );
              },
            ),
    );
  }
}