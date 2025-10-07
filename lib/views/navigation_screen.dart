import 'package:crypto_portfolio_tracker/bloc/navigation/navigation_bloc.dart';
import 'package:crypto_portfolio_tracker/bloc/navigation/navigation_state.dart';
import 'package:crypto_portfolio_tracker/config/bloc_events.dart';
import 'package:crypto_portfolio_tracker/config/page_routes.dart';
import 'package:crypto_portfolio_tracker/utils/globals.dart';
import 'package:crypto_portfolio_tracker/views/add_coin_screen.dart';
import 'package:crypto_portfolio_tracker/views/home_screen.dart';
import 'package:crypto_portfolio_tracker/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    appContext = context;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        BlocEvents.pop();
        return;
      },
      child: Scaffold(
        body: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            return _currentRoute(state.currentRoute);
          },
        ),
      ),
    );
  }

  Widget _currentRoute(PageRoutes currentRoute) {
    switch (currentRoute) {
      case PageRoutes.home:
        return HomeScreen();
      case PageRoutes.addCoin:
        return AddCoinScreen();

      default:
        return SplashScreen();
    }
  }
}
