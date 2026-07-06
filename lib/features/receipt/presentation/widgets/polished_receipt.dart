import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/receipt_result.dart';
import 'receipt_summary_rows.dart';

class PolishedReceipt extends StatelessWidget {
  const PolishedReceipt({
    super.key,
    required this.restaurantName,
    required this.currencySymbol,
    required this.result,
    required this.date,
  });

  final String restaurantName;
  final String currencySymbol;
  final ReceiptResult result;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final displayName = restaurantName.trim().isEmpty
        ? "L'Addition"
        : restaurantName.trim();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(displayName, style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(AppDateUtils.formatReceiptDate(date)),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Each diner owes',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final diner in result.diners) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      diner.dinerName.trim().isEmpty
                          ? 'Diner'
                          : diner.dinerName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Text(
                    CurrencyUtils.formatAmount(
                      diner.total,
                      symbol: currencySymbol,
                    ),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            const Divider(height: AppSpacing.xl),
            ReceiptSummaryRows(
              currencySymbol: currencySymbol,
              rows: [
                ReceiptSummaryRowData('Subtotal', result.subtotal),
                if (result.service != 0)
                  ReceiptSummaryRowData('Service', result.service),
                if (result.tax != 0) ReceiptSummaryRowData('Tax', result.tax),
                if (result.adjustments != 0)
                  ReceiptSummaryRowData('Adjustments', result.adjustments),
                if (result.discount != 0)
                  ReceiptSummaryRowData('Discount', -result.discount),
                if (result.rounding != 0)
                  ReceiptSummaryRowData('Rounding', result.rounding),
                ReceiptSummaryRowData('Total', result.total),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
