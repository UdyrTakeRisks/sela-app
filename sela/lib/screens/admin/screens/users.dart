import 'package:flutter/material.dart';
import 'package:sela/screens/admin/services/admin_services.dart';

import '../models/User.dart'; // Import your User model

class UsersAdmin extends StatefulWidget {
  UsersAdmin({Key? key}) : super(key: key);

  @override
  _UsersAdminState createState() => _UsersAdminState();
}

class _UsersAdminState extends State<UsersAdmin> {
  late List<User> users = []; // List to hold users fetched from API

  @override
  void initState() {
    super.initState();
    // Call function to fetch users when widget initializes
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      List<User> fetchedUsers = await AdminServices.fetchUsersFromApi();
      setState(() {
        users = fetchedUsers;
      });
    } catch (e) {
      // Handle error fetching users
      print('Error fetching users: $e');
      // Optionally show a snackbar or dialog to inform the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Admin'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: users[index].userPhoto != null
                  ? NetworkImage(users[index].userPhoto!)
                  : const AssetImage('assets/images/profile.png')
                      as ImageProvider,
            ),
            title: Text(users[index].username),
            subtitle: Text(users[index].email),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Implement delete functionality here
                _showDeleteConfirmationDialog(context, users[index]);
              },
            ),
            onTap: () {
              // Implement navigation to user details screen
              _navigateToUserDetails(context, users[index]);
            },
          );
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, User user) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: Text('Are you sure you want to delete ${user.username}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Perform delete operation here (call API or perform logic)
                _deleteUser(user);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(User user) {
    // Implement delete logic here (call API, update state, etc.)
    // Example: AdminServices.deleteUser(user.userId);
    print('Deleting user: ${user.username}');
    setState(() {
      users.remove(user);
    });
  }

  void _navigateToUserDetails(BuildContext context, User user) {
    // Implement navigation logic to user details screen
    // Example: Navigator.pushNamed(context, UserDetailsScreen.routeName, arguments: user);
    // Replace with your actual navigation logic
  }
}
