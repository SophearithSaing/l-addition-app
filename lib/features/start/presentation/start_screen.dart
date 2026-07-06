import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.containerPaddingMobile,
            AppSpacing.containerPaddingMobile,
            AppSpacing.containerPaddingMobile,
            AppSpacing.containerPaddingMobile + bottomInset,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'The Art of the Split',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Turn restaurant receipts into clear, elegant per-diner totals.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton.primary(
                label: 'Upload Receipt',
                onPressed: () {
                  context.goNamed(
                    RouteNames.login,
                    queryParameters: const {'redirect': RoutePaths.scan},
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton.secondary(
                label: 'Start Manual Entry',
                onPressed: () => context.goNamed(RouteNames.manualEntry),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
