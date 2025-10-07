import 'package:crypto_portfolio_tracker/models/coin.dart';

abstract class HomeEvent {}

class LoadCryptoCurrencies extends HomeEvent {}

class FilterCoins extends HomeEvent {
  final String query;
  FilterCoins(this.query);
}

class ClearFilter extends HomeEvent {}

class SelectCoin extends HomeEvent {
  final Coin coin;
  SelectCoin(this.coin);
}

class UpdateCoinQuantity extends HomeEvent {
  final double quantity;
  UpdateCoinQuantity(this.quantity);
}

class AddCoinToPortfolio extends HomeEvent {}

class LoadPortfolio extends HomeEvent {}

class DeteleteCoinFromPortfolio extends HomeEvent {
  final String coinId;
  DeteleteCoinFromPortfolio(this.coinId);
}

class UpdatePortfolioCoinsPrices extends HomeEvent {}
