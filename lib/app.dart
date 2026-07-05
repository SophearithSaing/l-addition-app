import 'package:flutter/material.dart';

class LAdditionApp extends StatelessWidget {
  const LAdditionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "L'Addition",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1C1C1A)),
        useMaterial3: true,
      ),
      home: const _AppPlaceholder(),
    );
  }
}

class _AppPlaceholder extends StatelessWidget {
  const _AppPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("L'Addition")));
  }
}
