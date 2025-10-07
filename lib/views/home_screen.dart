import 'package:crypto_portfolio_tracker/bloc/home/home_bloc.dart';
import 'package:crypto_portfolio_tracker/bloc/home/home_state.dart';
import 'package:crypto_portfolio_tracker/config/bloc_events.dart';
import 'package:crypto_portfolio_tracker/config/page_routes.dart';
import 'package:crypto_portfolio_tracker/models/coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    BlocEvents.loadCryptoCurrencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, bool>(
      selector: (state) {
        return state.isLoading;
      },
      builder: (context, isLoading) {
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                BlocEvents.updatePortfolioCoinsPrices();
              },
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text('Crypto Portfolio Tracker'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        BlocEvents.push(PageRoutes.addCoin);
                      },
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    const _PortfolioSection(),
                    const Divider(),
                    const _CoinsListSection(),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.50),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}

class _PortfolioSection extends StatelessWidget {
  const _PortfolioSection();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, List<Coin>>(
      selector: (state) => state.portfolioCoins,
      builder: (context, portfolioCoins) {
        if (portfolioCoins.isEmpty) {
          return const Text('No coins in portfolio. Add some!');
        }

        final totalPortfolioValue = portfolioCoins.fold<double>(
          0.0,
          (sum, coin) => sum + (coin.quantity * coin.price),
        );

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Portfolio',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Total: \$${formatNumber(totalPortfolioValue)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ...portfolioCoins.map((coin) {
                final price = coin.price;
                final quantity = coin.quantity;
                final total = quantity * price;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 8.0,
                  ),
                  child: Dismissible(
                    key: ValueKey(coin.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) async {
                      await BlocEvents.deleteCoinFromPortfolio(coin.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  coin.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  'Total: \$${formatNumber(total)}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Qty: ${formatNumber(quantity)} × \$${formatNumber(price)}',
                                style: const TextStyle(color: Colors.grey),
                              ),

                              IconButton(
                                onPressed: () {
                                  BlocEvents.deleteCoinFromPortfolio(coin.id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String formatNumber(double value) {
    if (value.abs() < 0.01 && value != 0) {
      // Use scientific notation for tiny numbers
      final formatted = value.toStringAsExponential(2);
      return formatted;
    } else {
      // Normal format with 2 decimal places
      final formatter = NumberFormat("#,##0.00");
      return formatter.format(value);
    }
  }
}

class _CoinsListSection extends StatelessWidget {
  const _CoinsListSection();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, List<Coin>>(
      selector: (state) {
        return state.coins;
      },
      builder: (context, coins) {
        if (coins.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No cryptocurrencies available.'),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: coins.length,
            itemBuilder: (context, index) {
              final coin = coins[index];

              return ListTile(
                leading: Icon(Icons.monetization_on),
                title: Text(coin.name),
                subtitle: Text(coin.symbol.toUpperCase()),
              );
            },
          ),
        );
      },
    );
  }
}
