import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : _variant = _AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : _variant = _AppButtonVariant.secondary;

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final _AppButtonVariant _variant;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;
    final child = _ButtonContent(
      label: label,
      icon: icon,
      isLoading: isLoading,
    );

    return switch (_variant) {
      _AppButtonVariant.primary => ElevatedButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
      _AppButtonVariant.secondary => OutlinedButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
    };
  }
}

enum _AppButtonVariant { primary, secondary }

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.isLoading,
  });

  final String label;
  final Widget? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[
      if (isLoading)
        SizedBox.square(
          dimension: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        )
      else if (icon != null)
        ?icon,
      if (isLoading || icon != null) const SizedBox(width: 8),
      Text(label),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: content,
    );
  }
}
