import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final destinations = const [
      NavigationDestination(icon: Icon(Icons.swipe), label: 'Swipe'),
      NavigationDestination(icon: Icon(Icons.bookmark), label: 'Saved'),
      NavigationDestination(icon: Icon(Icons.inventory), label: 'Inventory'),
      NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Offers'),
      NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
    ];

    if (kIsWeb || MediaQuery.of(context).size.width > 900) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: navigationShell.goBranch,
              destinations: destinations
                  .map((e) => NavigationRailDestination(icon: e.icon, label: Text(e.label)))
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: destinations,
        onDestinationSelected: navigationShell.goBranch,
      ),
    );
  }
}
