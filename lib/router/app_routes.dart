import 'package:calendar/core/models/event_model.dart';
import 'package:calendar/features/add_event_screen/add_event_screen.dart';
import 'package:calendar/features/event_view_screen/event_view_screen.dart';
import 'package:calendar/features/others/splash_screen.dart';
import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";

import '../features/home_screen/home_screen.dart';

part 'route_names.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      name: Routes.splash,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.home,
      name: Routes.home,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, __) => const HomeScreen(),
    ),
    GoRoute(
      path: Routes.add,
      name: Routes.add,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) => AddEventScreen(
        eventModel: state.extra as EventModel?,
      ),
    ),
    GoRoute(
      path: Routes.eventView,
      name: Routes.eventView,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) => EventViewScreen(
        eventModel: state.extra as EventModel,
      ),
    ),
  ],
);
