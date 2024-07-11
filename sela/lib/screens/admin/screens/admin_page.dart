import 'package:flutter/material.dart';
import 'package:sela/screens/admin/services/admin_services.dart';

import '../../../models/Individual.dart';
import '../../../models/Organizations.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<List<Organization>>? _organizationsFuture;
  Future<List<Individual>>? _individualsFuture;

  @override
  void initState() {
    super.initState();
    _organizationsFuture = AdminServices.fetchOrganizations();
    _individualsFuture = AdminServices.fetchIndividuals();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove the back button
          title: const Text('Admin Page'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                // Handle exit action here
                AdminServices.logout(context);
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Organizations'),
              Tab(text: 'Individuals'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrganizationsTab(),
            _buildIndividualsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationsTab() {
    return FutureBuilder<List<Organization>>(
      future: _organizationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No organizations found'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Organization org = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(org.name),
                    subtitle: Text(
                        org.title.isNotEmpty ? org.title : 'No description'),
                    leading: const Icon(Icons.business),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(org.name, org.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildIndividualsTab() {
    return FutureBuilder<List<Individual>>(
      future: _individualsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No individuals found'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Individual individual = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(individual.name),
                    subtitle: Text(individual.title.isNotEmpty
                        ? individual.title
                        : 'No title'),
                    leading: const Icon(Icons.person),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(
                                individual.name, individual.postId);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      String itemName, int postId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Are you sure you want to delete $itemName?'),
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
                // Call the delete function
                _deleteItem(postId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int postId) async {
    try {
      await AdminServices.deletePost(postId);
      // Refresh the list after deletion
      setState(() {
        _organizationsFuture = AdminServices.fetchOrganizations();
        _individualsFuture = AdminServices.fetchIndividuals();
      });
    } catch (e) {
      // Handle deletion error
      print('Error deleting item: $e');
    }
  }
}
