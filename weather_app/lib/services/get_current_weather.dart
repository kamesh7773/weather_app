// -------------------------------------
// Future Method (Fetching Weather info)
// -------------------------------------

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'get_current_city.dart';

Stream getCurrentWeatherData() async* {
  try {
    String? city = await getCurrentCity();
    const String apiKey = "271e0012511b565ecc6c3353740df270";
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$apiKey");

    final res = await http.get(url);
    final data = jsonDecode(res.body);

    if (data["cod"] != "200") {
      throw "An unexpected error occurred";
    }
    yield data;
  } catch (e) {
    throw e.toString();
  }
}
