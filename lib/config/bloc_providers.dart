import 'package:crypto_portfolio_tracker/bloc/home/home_bloc.dart';
import 'package:crypto_portfolio_tracker/bloc/navigation/navigation_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocProviders {
  BlocProviders._();

  static List providers(context) {
    return [
      BlocProvider(create: (context) => NavigationBloc()),
      BlocProvider(create: (context) => HomeBloc()),
    ];
  }
}
