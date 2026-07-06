import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/receipt_result.dart';
import 'receipt_summary_rows.dart';

class ClassicReceipt extends StatefulWidget {
  const ClassicReceipt({
    super.key,
    required this.restaurantName,
    required this.currencySymbol,
    required this.result,
    required this.date,
    this.qrBytes,
  });

  final String restaurantName;
  final String currencySymbol;
  final ReceiptResult result;
  final DateTime date;
  final Uint8List? qrBytes;

  @override
  State<ClassicReceipt> createState() => _ClassicReceiptState();
}

class _ClassicReceiptState extends State<ClassicReceipt> {
  final Set<int> _expandedDinerIds = <int>{};

  bool get _allExpanded =>
      _expandedDinerIds.length == widget.result.diners.length;

  void _toggleAll() {
    setState(() {
      if (_allExpanded) {
        _expandedDinerIds.clear();
      } else {
        _expandedDinerIds
          ..clear()
          ..addAll(widget.result.diners.map((diner) => diner.dinerId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.restaurantName.trim().isEmpty
                  ? "L'Addition"
                  : widget.restaurantName.trim(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppDateUtils.formatReceiptDate(widget.date),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextButton(
              onPressed: _toggleAll,
              child: Text(_allExpanded ? 'Collapse all' : 'Expand all'),
            ),
            for (final diner in widget.result.diners)
              _DinerBreakdown(
                diner: diner,
                currencySymbol: widget.currencySymbol,
                expanded: _expandedDinerIds.contains(diner.dinerId),
                onToggle: () {
                  setState(() {
                    if (_expandedDinerIds.contains(diner.dinerId)) {
                      _expandedDinerIds.remove(diner.dinerId);
                    } else {
                      _expandedDinerIds.add(diner.dinerId);
                    }
                  });
                },
              ),
            const Divider(height: AppSpacing.xl),
            ReceiptSummaryRows(
              currencySymbol: widget.currencySymbol,
              rows: [
                ReceiptSummaryRowData('Subtotal', widget.result.subtotal),
                if (widget.result.service != 0)
                  ReceiptSummaryRowData('Service', widget.result.service),
                if (widget.result.tax != 0)
                  ReceiptSummaryRowData('Tax', widget.result.tax),
                if (widget.result.adjustments != 0)
                  ReceiptSummaryRowData(
                    'Adjustments',
                    widget.result.adjustments,
                  ),
                if (widget.result.discount != 0)
                  ReceiptSummaryRowData('Discount', -widget.result.discount),
                if (widget.result.rounding != 0)
                  ReceiptSummaryRowData('Rounding', widget.result.rounding),
                ReceiptSummaryRowData('Total', widget.result.total),
              ],
            ),
            if (widget.qrBytes != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Image.memory(
                  widget.qrBytes!,
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DinerBreakdown extends StatelessWidget {
  const _DinerBreakdown({
    required this.diner,
    required this.currencySymbol,
    required this.expanded,
    required this.onToggle,
  });

  final DinerReceiptResult diner;
  final String currencySymbol;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: expanded,
      onExpansionChanged: (_) => onToggle(),
      title: Text(diner.dinerName.trim().isEmpty ? 'Diner' : diner.dinerName),
      trailing: Text(
        CurrencyUtils.formatAmount(diner.total, symbol: currencySymbol),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      children: [
        for (final item in diner.items)
          _Line(
            label: item.name.isEmpty ? 'Item' : item.name,
            amount: item.amount,
            symbol: currencySymbol,
          ),
        for (final item in diner.sharedItems)
          _Line(
            label:
                '${item.item.name.isEmpty ? 'Shared item' : item.item.name} (shared)',
            amount: item.amount,
            symbol: currencySymbol,
          ),
        if (diner.service != 0)
          _Line(
            label: 'Service',
            amount: diner.service,
            symbol: currencySymbol,
          ),
        if (diner.tax != 0)
          _Line(label: 'Tax', amount: diner.tax, symbol: currencySymbol),
        if (diner.adjustments != 0)
          _Line(
            label: 'Adjustments',
            amount: diner.adjustments,
            symbol: currencySymbol,
          ),
        if (diner.discount != 0)
          _Line(
            label: 'Discount',
            amount: -diner.discount,
            symbol: currencySymbol,
          ),
        if (diner.rounding != 0)
          _Line(
            label: 'Rounding',
            amount: diner.rounding,
            symbol: currencySymbol,
          ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.amount,
    required this.symbol,
  });

  final String label;
  final double amount;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(CurrencyUtils.formatAmount(amount, symbol: symbol)),
        ],
      ),
    );
  }
}
