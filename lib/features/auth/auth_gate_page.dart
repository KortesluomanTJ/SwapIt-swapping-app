import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthGatePage extends StatefulWidget {
  const AuthGatePage({super.key});

  @override
  State<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends State<AuthGatePage> {
  bool _phoneVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SwapIt Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Email/password auth + OTP phone verification required before listing/offering.'),
                const SizedBox(height: 12),
                TextField(decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 8),
                TextField(decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                const SizedBox(height: 8),
                TextField(decoration: const InputDecoration(labelText: 'Phone')), 
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => setState(() => _phoneVerified = true),
                  child: const Text('Verify Phone OTP (stub)'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _phoneVerified ? () => context.go('/swipe') : null,
                  child: const Text('Continue'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
