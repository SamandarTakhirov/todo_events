part of "app_routes.dart";

sealed class Routes {
  Routes._();

  static const String initial = "/";

  static const String splash = "/splash";
  static const String home = "/home";
  static const String add = "/add";
  static const String eventView = "/eventView";
}
