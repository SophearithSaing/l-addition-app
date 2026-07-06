import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';

class ReceiptActionBar extends StatelessWidget {
  const ReceiptActionBar({
    super.key,
    required this.onShare,
    this.isSharing = false,
  });

  final VoidCallback? onShare;
  final bool isSharing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(
          label: 'Export / Share PNG',
          onPressed: onShare,
          isLoading: isSharing,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'A receipt image will be generated and opened in your share sheet.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
