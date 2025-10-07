import 'package:bloc/bloc.dart';
import 'package:crypto_portfolio_tracker/bloc/navigation/navigation_event.dart';
import 'package:crypto_portfolio_tracker/bloc/navigation/navigation_state.dart';
import 'package:crypto_portfolio_tracker/config/page_routes.dart';
import 'package:crypto_portfolio_tracker/utils/globals.dart';
import 'package:flutter/material.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState()) {
    on<Push>(_push);
    on<PushAndRemoveUntil>(_pushAndRemoveUntil);
    on<Pop>(_pop);
  }

  void _push(Push event, Emitter<NavigationState> emit) {
    try {
      final targetRoute = event.route;
      List<PageRoutes> routes = [...state.routes];
      routes.add(targetRoute);
      emit(state.copyWith(currentRoute: targetRoute, routes: routes));
    } catch (_) {}
  }

  void _pushAndRemoveUntil(
    PushAndRemoveUntil event,
    Emitter<NavigationState> emit,
  ) {
    try {
      final targetRoute = event.route;
      List<PageRoutes> routes = [];
      if (event.rootRoute != null) routes.add(event.rootRoute!);
      routes.add(targetRoute);
      emit(state.copyWith(currentRoute: targetRoute, routes: routes));
    } catch (_) {}
  }

  void _pop(Pop event, Emitter<NavigationState> emit) {
    try {
      if (event.fromBottomSheet == true && Navigator.of(appContext).canPop()) {
        Navigator.of(appContext).pop();
        return;
      }

      if (state.routes.length > 1) {
        List<PageRoutes> routes = state.routes;
        routes.removeAt(routes.length - 1);
        emit(
          state.copyWith(
            currentRoute: routes[routes.length - 1],
            routes: routes,
          ),
        );
      }
    } catch (_) {}
  }
}
