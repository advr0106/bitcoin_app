import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '4AB37C86-7740-4489-BEB3-F2BE10A68D97';
const apiUrl = 'https://rest.coinapi.io/v1/exchangerate';

class CryptoExchangeService {
  Future<double?> getExchangeRate(String crypto, String currency) async {
    final url = Uri.parse('$apiUrl/$crypto/$currency');
    final response = await http.get(
      url,
      headers: {
        'X-CoinAPI-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['rate'];
    } else {
      print('Failed to get exchange rate: ${response.statusCode}');
      return null;
    }
  }
}
