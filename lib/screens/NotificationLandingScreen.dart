// lib/screens/notificationLandingScreen.dart
import 'package:flutter/material.dart';

class NotificationLandingScreen extends StatelessWidget {
  const NotificationLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification Details")),
      body: const Center(
        child: Text(
          "Opened via notification!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
