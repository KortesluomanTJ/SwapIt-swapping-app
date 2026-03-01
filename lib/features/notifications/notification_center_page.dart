import 'package:flutter/material.dart';

class NotificationCenterPage extends StatelessWidget {
  const NotificationCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const ListTile(
        title: Text('In-app notifications center (required for web).'),
        subtitle: Text('Push for mobile is wired via edge function dispatcher stub.'),
      ),
    );
  }
}
