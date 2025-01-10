import 'package:flutter/material.dart';
import 'api_service.dart'; // Replace with your actual ApiService import

class ManageAccountsPage extends StatefulWidget {
  const ManageAccountsPage({super.key});

  @override
  _ManageAccountsPageState createState() => _ManageAccountsPageState();
}

class _ManageAccountsPageState extends State<ManageAccountsPage> {
  final ApiService apiService = ApiService(baseUrl: 'http://localhost:5196'); // Update backend URL
  List<Map<String, dynamic>> _users = [];
  String _searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await apiService.get('/api/AdminDashboard/users?page=1&pageSize=50');
      if (response is List) {
        setState(() {
          _users = response.map((user) {
            return {
              'id': user['id'],
              'name': user['name'] ?? 'Unknown',
              'status': user['status'] ?? 'Inactive',
              'type': user['role'] ?? 'User',
              'phone': user['phone'] ?? 'N/A',
              'service': user['service'] ?? '', // For service providers
            };
          }).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _toggleUserStatus(String userId, String currentStatus) async {
    try {
      if (currentStatus == 'Active') {
        await apiService.post('/api/AdminDashboard/users/$userId/deactivate', {});
        setState(() {
          final userIndex = _users.indexWhere((user) => user['id'] == userId);
          if (userIndex != -1) {
            _users[userIndex]['status'] = 'Inactive';
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deactivated successfully!')),
        );
      } else {
        // Simulate activation (add activation endpoint logic here)
        setState(() {
          final userIndex = _users.indexWhere((user) => user['id'] == userId);
          if (userIndex != -1) {
            _users[userIndex]['status'] = 'Active';
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User activated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users.where((user) {
      final query = _searchQuery.toLowerCase();
      return user['name'].toLowerCase().contains(query) || user['phone'].toLowerCase().contains(query);
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredUsers.isEmpty
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
                                      color: user['status'] == 'Active' ? Colors.green : Colors.red,
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
                            if (value == 'Toggle Status') {
                              _toggleUserStatus(user['id'], user['status']);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'Toggle Status', child: Text('Toggle Status')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
