import 'package:flutter/material.dart';

import 'core/routing/app_router.dart';

class LAdditionApp extends StatelessWidget {
  const LAdditionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "L'Addition",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1C1C1A)),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
