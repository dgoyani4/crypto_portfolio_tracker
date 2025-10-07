import 'dart:io';

import 'package:crypto_portfolio_tracker/config/bloc_providers.dart';
import 'package:crypto_portfolio_tracker/views/navigation_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: List<SingleChildWidget>.from(BlocProviders.providers(context)),
      child: MaterialApp(
        debugShowCheckedModeBanner: kDebugMode,
        title: 'Crypto Portfolio Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Container(
          color: Colors.black,
          padding: EdgeInsets.only(
            bottom: Platform.isIOS
                ? MediaQuery.paddingOf(context).bottom / 1.5
                : 0,
          ),
          child: const NavigationScreen(),
        ),
      ),
    );
  }
}
