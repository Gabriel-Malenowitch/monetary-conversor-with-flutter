import 'dart:convert';

import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
const ULTRA_SAFE_BUT_NOT_SIMPLE_SAVE_BUT_THE_SAFETIER_API_KEY =
    "D5B5B1DD-8B7C-47D8-8C92-94D50FBFC075";
// ignore: constant_identifier_names
const BASE_URL = 'https://rest.coinapi.io/v1/exchangerate';

class Exchangerate {
  late String time;
  // ignore: non_constant_identifier_names
  late String asset_id_base;
  // ignore: non_constant_identifier_names
  late String asset_id_quote;
  late double rate;
}

class Http {
  Future<Exchangerate?> exchangerate(String keyA, String keyB) async {
    final paramA = keyA.toUpperCase();
    final paramB = keyB.toUpperCase();
    final response = await http
        .get(Uri.parse('$BASE_URL/$paramA/$paramB'), headers: {
      'X-CoinAPI-Key': ULTRA_SAFE_BUT_NOT_SIMPLE_SAVE_BUT_THE_SAFETIER_API_KEY
    });
    final decoded = jsonDecode(response.body);
    final result = Exchangerate();

    result.time = decoded['time'];
    result.asset_id_base = decoded['asset_id_base'];
    result.asset_id_quote = decoded['asset_id_quote'];
    result.rate = decoded['rate'];

    return result;
  }
}
