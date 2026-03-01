import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_gate_page.dart';
import '../features/common/shell_page.dart';
import '../features/item/item_detail_page.dart';
import '../features/offers/offer_thread_page.dart';

final appRouter = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(path: '/auth', builder: (_, __) => const AuthGatePage()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navShell) => ShellPage(navigationShell: navShell),
      branches: [
        StatefulShellBranch(routes: [GoRoute(path: '/swipe', builder: (_, __) => const Placeholder(child: Center(child: Text('Swipe Feed'))))]),
        StatefulShellBranch(routes: [GoRoute(path: '/saved', builder: (_, __) => const Placeholder(child: Center(child: Text('Saved'))))]),
        StatefulShellBranch(routes: [GoRoute(path: '/inventory', builder: (_, __) => const Placeholder(child: Center(child: Text('Inventory'))))]),
        StatefulShellBranch(routes: [GoRoute(path: '/offers', builder: (_, __) => const Placeholder(child: Center(child: Text('Offers Inbox'))))]),
        StatefulShellBranch(routes: [GoRoute(path: '/profile', builder: (_, __) => const Placeholder(child: Center(child: Text('Profile & Settings'))))]),
      ],
    ),
    GoRoute(path: '/item/:id', builder: (_, state) => ItemDetailPage(itemId: state.pathParameters['id']!)),
    GoRoute(path: '/offer/:id', builder: (_, state) => OfferThreadPage(offerId: state.pathParameters['id']!)),
  ],
);
