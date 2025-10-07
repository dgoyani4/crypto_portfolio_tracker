import 'package:crypto_portfolio_tracker/bloc/home/home_event.dart';
import 'package:crypto_portfolio_tracker/bloc/home/home_repository.dart';
import 'package:crypto_portfolio_tracker/bloc/home/home_state.dart';
import 'package:crypto_portfolio_tracker/config/bloc_events.dart';
import 'package:crypto_portfolio_tracker/database/portfoilio_db.dart';
import 'package:crypto_portfolio_tracker/models/coin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<LoadCryptoCurrencies>(_loadCryptoCurrencies);
    on<FilterCoins>(_filterCoins);
    on<ClearFilter>(_clearFilter);
    on<SelectCoin>(_selectCoin);
    on<UpdateCoinQuantity>(_updateCoinQuantity);
    on<AddCoinToPortfolio>(_addCoinToPortfolio);
    on<LoadPortfolio>(_loadPortfolio);
    on<DeteleteCoinFromPortfolio>(_deleteCoinFromPortfolio);
    on<UpdatePortfolioCoinsPrices>(_updatePortfolioCoinsPrices);
  }

  final HomeRepository _repository = HomeRepository();

  Future<void> _loadCryptoCurrencies(
    LoadCryptoCurrencies event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state.coins.isNotEmpty) {
        await _loadPortfolio(LoadPortfolio(), emit);
        return;
      }

      if (state.isLoading) return;
      emit(state.copyWith(isLoading: true));

      final response = await _repository.loadCryptoCurrencies();

      if (response.isNotEmpty) {
        emit(
          state.copyWith(
            coins: List<Coin>.from(response.map((x) => Coin.fromMap(x))),
          ),
        );
      }

      emit(state.copyWith(isLoading: false));
      await _loadPortfolio(LoadPortfolio(), emit);
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _filterCoins(FilterCoins event, Emitter<HomeState> emit) async {
    final query = event.query.toLowerCase();

    try {
      if (query.isEmpty) {
        state.filteredCoins = null;
      } else {
        final filtered = state.coins.where((coin) {
          return coin.name.toLowerCase().contains(query) ||
              coin.symbol.toLowerCase().contains(query) ||
              coin.id.toLowerCase().contains(query);
        }).toList();

        emit(state.copyWith(filteredCoins: filtered));
      }
    } catch (_) {
      state.filteredCoins = null;
    }
  }

  void _clearFilter(ClearFilter event, Emitter<HomeState> emit) {
    state.filteredCoins = null;
    emit(state.copyWith(filteredCoins: null));
  }

  Future<void> _selectCoin(SelectCoin event, Emitter<HomeState> emit) async {
    try {
      if (state.isLoading) return;
      emit(state.copyWith(isLoading: true));

      final price = await _repository.loadCryptoPrice(event.coin.id);
      final selectedCoin = event.coin.copyWith(price: price);

      emit(
        state.copyWith(
          selectedCoin: selectedCoin,
          quantity: 0.0,
          totalQuantityValue: 0.0,
        ),
      );

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(selectedCoin: null, quantity: 0.0, isLoading: false));
    }
  }

  void _updateCoinQuantity(UpdateCoinQuantity event, Emitter<HomeState> emit) {
    try {
      final quantity = event.quantity;
      final totalQuantityValue = (state.selectedCoin?.price ?? 0.0) * quantity;

      emit(
        state.copyWith(
          quantity: quantity,
          totalQuantityValue: totalQuantityValue,
        ),
      );
    } catch (_) {
      emit(state.copyWith(quantity: 0.0, totalQuantityValue: 0.0));
    }
  }

  Future<void> _addCoinToPortfolio(
    AddCoinToPortfolio event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state.isLoading) return;
      emit(state.copyWith(isLoading: true));

      final selectedCoin = state.selectedCoin;
      final quantity = state.quantity;

      if (selectedCoin == null || quantity <= 0) return;

      final coinData = {
        'id': selectedCoin.id,
        'name': selectedCoin.name,
        'symbol': selectedCoin.symbol,
        'price': selectedCoin.price,
        'quantity': quantity,
      };

      await PortfolioDB.instance.insertOrUpdateCoin(coinData);

      BlocEvents.pop();
      state.selectedCoin = null;
      emit(
        state.copyWith(
          selectedCoin: null,
          quantity: 0.0,
          totalQuantityValue: 0.0,
          isLoading: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _loadPortfolio(
    LoadPortfolio event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      final portfolioData = await PortfolioDB.instance.fetchPortfolio();

      final portfolioCoins = portfolioData
          .map((data) => Coin.fromMap(data))
          .toList();

      emit(state.copyWith(portfolioCoins: portfolioCoins, isLoading: false));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _deleteCoinFromPortfolio(
    DeteleteCoinFromPortfolio event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      await PortfolioDB.instance.deleteCoin(event.coinId);

      final updatedPortfolioCoins = state.portfolioCoins
          .where((coin) => coin.id != event.coinId)
          .toList();

      emit(
        state.copyWith(portfolioCoins: updatedPortfolioCoins, isLoading: false),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _updatePortfolioCoinsPrices(
    UpdatePortfolioCoinsPrices event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state.isLoading || state.portfolioCoins.isEmpty) return;
      emit(state.copyWith(isLoading: true));

      final updatedCoins = <Coin>[];

      for (final coin in state.portfolioCoins) {
        final price = await _repository.loadCryptoPrice(coin.id);
        updatedCoins.add(coin.copyWith(price: price));
      }

      emit(state.copyWith(portfolioCoins: updatedCoins, isLoading: false));

      BlocEvents.showSnackbar('Portfolio prices updated!');
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
