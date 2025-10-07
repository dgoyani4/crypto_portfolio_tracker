import 'package:crypto_portfolio_tracker/config/bloc_events.dart';
import 'package:dio/dio.dart';

class HomeRepository {
  HomeRepository();

  static Dio dio = Dio();

  Future<List<Map<String, dynamic>>> loadCryptoCurrencies() async {
    try {
      final response = await dio.get(
        'https://api.coingecko.com/api/v3/coins/list',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return List<Map<String, dynamic>>.from(data);
      } else {
        return [];
      }
    } catch (e) {
      BlocEvents.showSnackbar(e.toString());
      return [];
    }
  }

  Future<double> loadCryptoPrice(String id) async {
    try {
      final response = await dio.get(
        'https://api.coingecko.com/api/v3/simple/price',
        queryParameters: {'ids': id, 'vs_currencies': 'usd'},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return (data[id]['usd'] ?? 0.0).toDouble();
      } else {
        return 0.0;
      }
    } catch (e) {
      BlocEvents.showSnackbar(e.toString());
      return 0.0;
    }
  }
}
