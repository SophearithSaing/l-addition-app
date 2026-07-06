import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/number_parsing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/loading_state.dart';
import '../../receipt/domain/currency_config.dart';
import '../../receipt/domain/receipt_input.dart';
import 'manual_bill_controller.dart';

class ManualEntryScreen extends ConsumerWidget {
  const ManualEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(manualBillControllerProvider);
    final controller = ref.read(manualBillControllerProvider.notifier);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(title: const Text('Manual Entry')),
      body: state.when(
        loading: () => const LoadingState(message: 'Restoring draft…'),
        error: (error, stackTrace) =>
            Center(child: Text('Could not load draft: $error')),
        data: (bill) => ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.containerPaddingMobile,
            AppSpacing.containerPaddingMobile,
            AppSpacing.containerPaddingMobile,
            AppSpacing.containerPaddingMobile + bottomInset,
          ),
          children: [
            Text(
              'Bill details',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Restaurant name',
              initialValue: bill.restaurantName,
              onChanged: controller.setRestaurantName,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<CurrencyType>(
              initialValue: bill.currency.type,
              decoration: const InputDecoration(labelText: 'Currency'),
              items: const [
                DropdownMenuItem(
                  value: CurrencyType.thb,
                  child: Text('Thai baht ฿'),
                ),
                DropdownMenuItem(
                  value: CurrencyType.usd,
                  child: Text('US dollar \$'),
                ),
                DropdownMenuItem(
                  value: CurrencyType.custom,
                  child: Text('Custom'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.setCurrency(bill.currency.copyWith(type: value));
                }
              },
            ),
            if (bill.currency.type == CurrencyType.custom) ...[
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Custom symbol',
                initialValue: bill.currency.customSymbol,
                onChanged: (value) => controller.setCurrency(
                  bill.currency.copyWith(customSymbol: value),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            _SectionHeader(
              title: 'Diners',
              actionLabel: 'Add diner',
              onAction: controller.addDiner,
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final diner in bill.diners) ...[
              AppCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Diner name',
                            initialValue: diner.name,
                            onChanged: (value) =>
                                controller.updateDinerName(diner.id, value),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remove diner',
                          onPressed: () => controller.removeDiner(diner.id),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (final item in diner.items)
                      _LineItemRow(
                        name: item.name,
                        amount: item.amount,
                        onNameChanged: (value) => controller.updateDinerItem(
                          diner.id,
                          item.id,
                          name: value,
                        ),
                        onAmountChanged: (value) => controller.updateDinerItem(
                          diner.id,
                          item.id,
                          amount: value,
                        ),
                        onRemove: () =>
                            controller.removeDinerItem(diner.id, item.id),
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => controller.addDinerItem(diner.id),
                        icon: const Icon(Icons.add),
                        label: const Text('Add item'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.xl),
            _SectionHeader(
              title: 'Shared items',
              actionLabel: 'Add shared item',
              onAction: controller.addSharedItem,
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final item in bill.sharedItems) ...[
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LineItemRow(
                      name: item.name,
                      amount: item.amount,
                      onNameChanged: (value) =>
                          controller.updateSharedItem(item.id, name: value),
                      onAmountChanged: (value) =>
                          controller.updateSharedItem(item.id, amount: value),
                      onRemove: () => controller.removeSharedItem(item.id),
                    ),
                    Wrap(
                      spacing: AppSpacing.xs,
                      children: [
                        for (final diner in bill.diners)
                          FilterChip(
                            label: Text(
                              diner.name.isEmpty
                                  ? 'Diner ${diner.id}'
                                  : diner.name,
                            ),
                            selected: item.participantIds.contains(diner.id),
                            onSelected: (selected) {
                              final participants = {...item.participantIds};
                              selected
                                  ? participants.add(diner.id)
                                  : participants.remove(diner.id);
                              controller.updateSharedItem(
                                item.id,
                                participantIds: participants,
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Summary controls',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            _NumberField(
              label: 'Service charge %',
              value: bill.serviceRate,
              onChanged: controller.setServiceRate,
            ),
            _NumberField(
              label: 'Tax rate %',
              value: bill.taxRate,
              onChanged: controller.setTaxRate,
            ),
            _NumberField(
              label: 'Discount',
              value: bill.discount,
              onChanged: controller.setDiscount,
            ),
            DropdownButtonFormField<DiscountType>(
              initialValue: bill.discountType,
              decoration: const InputDecoration(labelText: 'Discount type'),
              items: const [
                DropdownMenuItem(
                  value: DiscountType.fixed,
                  child: Text('Fixed amount'),
                ),
                DropdownMenuItem(
                  value: DiscountType.percentage,
                  child: Text('Percentage'),
                ),
              ],
              onChanged: (value) {
                if (value != null) controller.setDiscountType(value);
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Round final total'),
              value: bill.roundingEnabled,
              onChanged: controller.setRoundingEnabled,
            ),
            const SizedBox(height: AppSpacing.md),
            _SectionHeader(
              title: 'Adjustments',
              actionLabel: 'Add adjustment',
              onAction: controller.addAdjustment,
            ),
            for (final adjustment in bill.adjustments)
              _LineItemRow(
                name: adjustment.label,
                amount: adjustment.amount,
                nameLabel: 'Label',
                onNameChanged: (value) =>
                    controller.updateAdjustment(adjustment.id, label: value),
                onAmountChanged: (value) =>
                    controller.updateAdjustment(adjustment.id, amount: value),
                onRemove: () => controller.removeAdjustment(adjustment.id),
              ),
            const SizedBox(height: AppSpacing.xl),
            AppButton.primary(
              label: 'Generate receipt',
              onPressed: bill.hasBillItems
                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Receipt preview will be wired next.'),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton.secondary(
              label: 'Clear bill',
              onPressed: () async {
                final confirmed = await ConfirmationDialog.show(
                  context,
                  title: 'Clear bill?',
                  message: 'This removes the current bill and saved draft.',
                  confirmLabel: 'Clear',
                  isDestructive: true,
                );
                if (confirmed) await controller.clearBill();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        ),
        TextButton.icon(
          onPressed: onAction,
          icon: const Icon(Icons.add),
          label: Text(actionLabel),
        ),
      ],
    );
  }
}

class _LineItemRow extends StatelessWidget {
  const _LineItemRow({
    required this.name,
    required this.amount,
    required this.onNameChanged,
    required this.onAmountChanged,
    required this.onRemove,
    this.nameLabel = 'Item name',
  });

  final String name;
  final double amount;
  final String nameLabel;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<double> onAmountChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            label: nameLabel,
            initialValue: name,
            onChanged: onNameChanged,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 100,
          child: _NumberField(
            label: 'Amount',
            value: amount,
            onChanged: onAmountChanged,
          ),
        ),
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.remove_circle_outline),
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      initialValue: value == 0 ? '' : value.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (raw) {
        final parsed = NumberParsing.parseNonNegative(raw);
        if (parsed != null) onChanged(parsed);
        if (raw.trim().isEmpty) onChanged(0);
      },
    );
  }
}
