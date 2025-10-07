import 'package:crypto_portfolio_tracker/models/coin.dart';

class HomeState {
  final bool isLoading;
  final List<Coin> coins;
  final List<Coin> portfolioCoins;
  List<Coin>? filteredCoins;
  Coin? selectedCoin;
  final double quantity;
  final double totalQuantityValue;

  HomeState({
    this.isLoading = false,
    this.coins = const [],
    this.portfolioCoins = const [],
    this.filteredCoins,
    this.selectedCoin,
    this.quantity = 0.0,
    this.totalQuantityValue = 0.0,
  });

  HomeState copyWith({
    bool? isLoading,
    List<Coin>? coins,
    List<Coin>? portfolioCoins,
    List<Coin>? filteredCoins,
    Coin? selectedCoin,
    double? quantity,
    double? totalQuantityValue,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      coins: coins ?? this.coins,
      portfolioCoins: portfolioCoins ?? this.portfolioCoins,
      filteredCoins: filteredCoins ?? this.filteredCoins,
      selectedCoin: selectedCoin ?? this.selectedCoin,
      quantity: quantity ?? this.quantity,
      totalQuantityValue: totalQuantityValue ?? this.totalQuantityValue,
    );
  }
}
