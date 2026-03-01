import 'package:flutter/material.dart';

class OfferThreadPage extends StatelessWidget {
  const OfferThreadPage({super.key, required this.offerId});

  final String offerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offer Thread $offerId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Offer revisions, counter offers, accept/decline, and lock/unlock logic are server-enforced.'),
          SizedBox(height: 8),
          Text('Chat is tied to offer and uses Supabase realtime channel.'),
        ],
      ),
    );
  }
}
