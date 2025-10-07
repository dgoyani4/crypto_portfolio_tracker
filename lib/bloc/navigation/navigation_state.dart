import 'package:crypto_portfolio_tracker/config/page_routes.dart';

class NavigationState {
  final PageRoutes currentRoute;
  final List<PageRoutes> routes;

  NavigationState({
    this.currentRoute = PageRoutes.splash,
    this.routes = const [],
  });

  NavigationState copyWith({
    PageRoutes? currentRoute,
    List<PageRoutes>? routes,
  }) {
    return NavigationState(
      currentRoute: currentRoute ?? this.currentRoute,
      routes: routes ?? this.routes,
    );
  }
}
