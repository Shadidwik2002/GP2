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
  ];

  String _searchQuery = '';
//a
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

  void _editUserDetails(BuildContext context, int index) {
    final user = _users[index];
    final TextEditingController nameController = TextEditingController(text: user['name']);
    final TextEditingController phoneController = TextEditingController(text: user['phone']);
    final TextEditingController serviceController = TextEditingController(text: user['service'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Details for ${user['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            if (user['type'] == 'Service Provider')
              TextField(
                controller: serviceController,
                decoration: const InputDecoration(labelText: 'Service'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _users[index]['name'] = nameController.text;
                _users[index]['phone'] = phoneController.text;
                if (user['type'] == 'Service Provider') {
                  _users[index]['service'] = serviceController.text;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User details updated successfully!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users.where((user) {
      final query = _searchQuery.toLowerCase();
      return user['name']!.toLowerCase().contains(query) ||
          user['phone']!.toLowerCase().contains(query);
    }).toList();

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
              hintText: 'Search users by name or phone',
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
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Edit') {
                          _editUserDetails(context, index);
                        } else if (value == 'Toggle Status') {
                          _changeUserStatus(
                            context,
                            _users.indexOf(user),
                            user['status'] == 'Active' ? 'Inactive' : 'Active',
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'Toggle Status', child: Text('Toggle Status')),
                      ],
                    ),
                    onTap: () => _editUserDetails(context, index),
                  ),
                );
              },
            ),
    );
  }
}
