import 'package:go_router/go_router.dart';

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
  ],
);
