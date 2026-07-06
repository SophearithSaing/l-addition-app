import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/manual_bill/presentation/manual_entry_screen.dart';
import '../../features/receipt/presentation/receipt_preview_screen.dart';
import '../../features/scan/presentation/receipt_scan_screen.dart';
import '../../features/start/presentation/start_screen.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: RoutePaths.start,
  routes: [
    GoRoute(
      name: RouteNames.start,
      path: RoutePaths.start,
      builder: (context, state) => const StartScreen(),
    ),
    GoRoute(
      name: RouteNames.login,
      path: RoutePaths.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: RouteNames.signUp,
      path: RoutePaths.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      name: RouteNames.manualEntry,
      path: RoutePaths.manualEntry,
      builder: (context, state) => const ManualEntryScreen(),
    ),
    GoRoute(
      name: RouteNames.scan,
      path: RoutePaths.scan,
      builder: (context, state) => const ReceiptScanScreen(),
    ),
    GoRoute(
      name: RouteNames.receiptPreview,
      path: RoutePaths.receiptPreview,
      builder: (context, state) => const ReceiptPreviewScreen(),
    ),
  ],
);
