import 'package:crypto_portfolio_tracker/config/page_routes.dart';

abstract class NavigationEvent {}

class Push extends NavigationEvent {
  final PageRoutes route;
  Push(this.route);
}

class PushAndRemoveUntil extends NavigationEvent {
  final PageRoutes route;
  final PageRoutes? rootRoute;
  PushAndRemoveUntil(this.route, {this.rootRoute});
}

class Pop extends NavigationEvent {
  final bool? fromBottomSheet;
  Pop({this.fromBottomSheet});
}
