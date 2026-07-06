import 'package:flutter/material.dart';

class ReceiptCaptureBoundary extends StatelessWidget {
  const ReceiptCaptureBoundary({
    super.key,
    required this.boundaryKey,
    required this.child,
  });

  final GlobalKey boundaryKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(key: boundaryKey, child: child);
  }
}
