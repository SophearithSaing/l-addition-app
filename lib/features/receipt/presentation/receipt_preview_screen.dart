import 'package:flutter/material.dart';

class ReceiptPreviewScreen extends StatelessWidget {
  const ReceiptPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Receipt Preview'),
        ),
      ),
    );
  }
}
