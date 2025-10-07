import 'package:crypto_portfolio_tracker/bloc/home/home_bloc.dart';
import 'package:crypto_portfolio_tracker/bloc/home/home_event.dart';
import 'package:crypto_portfolio_tracker/bloc/navigation/navigation_bloc.dart';
import 'package:crypto_portfolio_tracker/bloc/navigation/navigation_event.dart';
import 'package:crypto_portfolio_tracker/config/page_routes.dart';
import 'package:crypto_portfolio_tracker/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlocEvents {
  static void showSnackbar(String message) {
    ScaffoldMessenger.of(
      appContext,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  BlocEvents._();

  static push(PageRoutes route) =>
      appContext.read<NavigationBloc>().add(Push(route));
  static pushAndRemoveUntil(PageRoutes route, {PageRoutes? rootRoute}) =>
      appContext.read<NavigationBloc>().add(
        PushAndRemoveUntil(route, rootRoute: rootRoute),
      );
  static pop({bool? fromBottomSheet}) => appContext.read<NavigationBloc>().add(
    Pop(fromBottomSheet: fromBottomSheet),
  );

  static loadCryptoCurrencies() =>
      appContext.read<HomeBloc>().add(LoadCryptoCurrencies());
  static filterCoins(String query) =>
      appContext.read<HomeBloc>().add(FilterCoins(query));
  static clearFilter() => appContext.read<HomeBloc>().add(ClearFilter());
  static selectCoin(coin) => appContext.read<HomeBloc>().add(SelectCoin(coin));
  static updateCoinQuantity(quantity) =>
      appContext.read<HomeBloc>().add(UpdateCoinQuantity(quantity));
  static addCoinToPortfolio() =>
      appContext.read<HomeBloc>().add(AddCoinToPortfolio());
  static loadPortfolio() => appContext.read<HomeBloc>().add(LoadPortfolio());
  static deleteCoinFromPortfolio(String coinId) =>
      appContext.read<HomeBloc>().add(DeteleteCoinFromPortfolio(coinId));
  static updatePortfolioCoinsPrices() =>
      appContext.read<HomeBloc>().add(UpdatePortfolioCoinsPrices());
}
