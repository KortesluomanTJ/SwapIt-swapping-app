import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class SwapItApp extends StatelessWidget {
  const SwapItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SwapIt',
      theme: buildSwapItTheme(),
      routerConfig: appRouter,
    );
  }
}
