import 'package:crypto_portfolio_tracker/bloc/home/home_bloc.dart';
import 'package:crypto_portfolio_tracker/bloc/home/home_state.dart';
import 'package:crypto_portfolio_tracker/config/bloc_events.dart';
import 'package:crypto_portfolio_tracker/models/coin.dart';
import 'package:crypto_portfolio_tracker/widgets/app_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCoinScreen extends StatefulWidget {
  const AddCoinScreen({super.key});

  @override
  State<AddCoinScreen> createState() => _AddCoinScreenState();
}

class _AddCoinScreenState extends State<AddCoinScreen> {
  final GlobalKey<FormFieldState<String>> _quantityFieldKey =
      GlobalKey<FormFieldState<String>>();
  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, bool>(
      selector: (state) {
        return state.isLoading;
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(title: Text('Add Coin to Portfolio')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    BlocSelector<HomeBloc, HomeState, Coin?>(
                      selector: (state) {
                        return state.selectedCoin;
                      },
                      builder: (context, selectedCoin) {
                        return AppTextFormField(
                          labelText: 'Select Coin',
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                          syncOnUpdate: true,
                          initialText: selectedCoin?.name,
                          readOnly: true,
                          onTap: () async {
                            await openCoinSelector();
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    BlocSelector<HomeBloc, HomeState, double>(
                      selector: (state) {
                        return state.quantity;
                      },
                      builder: (context, quantity) {
                        return AppTextFormField(
                          textFieldKey: _quantityFieldKey,
                          labelText: 'Quantity',
                          hintText: '0.0',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          syncOnUpdate: true,
                          initialText: quantity > 0
                              ? (quantity % 1 == 0
                                    ? quantity.toInt().toString()
                                    : quantity.toString())
                              : '',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter quantity';
                            }
                            final doubleValue = double.tryParse(value);
                            if (doubleValue == null) {
                              return 'Enter a valid number';
                            }
                            if (doubleValue <= 0) {
                              return 'Quantity must be greater than 0';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            BlocEvents.updateCoinQuantity(
                              double.tryParse(value) ?? 0.0,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    BlocSelector<HomeBloc, HomeState, double>(
                      selector: (state) {
                        return state.totalQuantityValue;
                      },
                      builder: (context, totalQuantityValue) {
                        return Expanded(
                          child: Text(
                            'Total: \$${totalQuantityValue.toStringAsFixed(8)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    BlocSelector<HomeBloc, HomeState, Coin?>(
                      selector: (state) => state.selectedCoin,
                      builder: (context, selectedCoin) {
                        return ElevatedButton(
                          onPressed: () async {
                            if (selectedCoin == null) {
                              BlocEvents.showSnackbar('Please select a coin.');

                              return;
                            }
                            final formState = _quantityFieldKey.currentState;
                            if (formState == null ||
                                formState.validate() != true) {
                              BlocEvents.showSnackbar(
                                'Please enter a valid quantity greater than 0.',
                              );

                              return;
                            }
                            final value = formState.value;
                            final doubleValue = double.tryParse(value ?? '');
                            if (doubleValue == null || doubleValue <= 0) {
                              BlocEvents.showSnackbar(
                                'Please enter a valid quantity greater than 0.',
                              );
                              return;
                            }
                            await BlocEvents.addCoinToPortfolio();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                          ),
                          child: Text('Add to Portfolio'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (state)
              Container(
                color: Colors.black.withValues(alpha: 0.50),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }

  Future<void> openCoinSelector() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocSelector<HomeBloc, HomeState, (List<Coin>, List<Coin>?)>(
          selector: (state) {
            return (state.coins, state.filteredCoins);
          },
          builder: (context, data) {
            final (coins, filteredCoins) = data;

            List<Coin> displayCoins = filteredCoins ?? coins;

            return Column(
              children: [
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AppTextFormField(
                    labelText: 'Search Coin',
                    hintText: 'Type to search...',
                    onChanged: (value) {
                      BlocEvents.filterCoins(value);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: displayCoins.length,
                    itemBuilder: (context, index) {
                      final coin = displayCoins[index];

                      return ListTile(
                        title: Text(coin.name),
                        subtitle: Text(coin.symbol.toUpperCase()),
                        onTap: () {
                          BlocEvents.selectCoin(coin);
                          BlocEvents.pop(fromBottomSheet: true);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      BlocEvents.clearFilter();
    });
  }
}
