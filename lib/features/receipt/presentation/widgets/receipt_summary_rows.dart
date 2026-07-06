import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_utils.dart';

class ReceiptSummaryRows extends StatelessWidget {
  const ReceiptSummaryRows({
    super.key,
    required this.currencySymbol,
    required this.rows,
  });

  final String currencySymbol;
  final List<ReceiptSummaryRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
            child: Row(
              children: [
                Expanded(child: Text(row.label)),
                Text(
                  CurrencyUtils.formatAmount(
                    row.amount,
                    symbol: currencySymbol,
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ReceiptSummaryRowData {
  const ReceiptSummaryRowData(this.label, this.amount);

  final String label;
  final double amount;
}
