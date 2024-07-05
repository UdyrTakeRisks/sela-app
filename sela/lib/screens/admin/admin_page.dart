import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  static const String routeName = '/admin';

  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Admin Page'),
      ),
    );
  }
}
