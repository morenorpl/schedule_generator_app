
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Center(
            child: ElevatedButton.icon(
          onPressed: () {
            Provider.of<AuthService>(context, listen: false).logout();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: const Icon(Icons.logout),
          label: const Text("Logout"),
        )));
  }
}
