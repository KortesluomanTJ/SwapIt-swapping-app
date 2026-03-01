import 'package:flutter/material.dart';

class ItemDetailPage extends StatelessWidget {
  const ItemDetailPage({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Item $itemId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Swap listing details with rough meetup label + rounded distance only.'),
          SizedBox(height: 12),
          Text('Offer builder supports 1+ offered items and optional note.'),
        ],
      ),
    );
  }
}
