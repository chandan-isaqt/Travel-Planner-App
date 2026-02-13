import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:traveling_app/model/weatherModel.dart';

Future<Weather?> fetchWeather(double lat, double lon) async {
  try {
    final apiKey = '0b6cb61b57f133a53e01346698a1c5b8';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return Weather(
        city: data['name'] ?? 'Unknown',
        temperature: (data['main']['temp'] as num).toDouble(),
        description: data['weather'][0]['description'] ?? '',
        iconCode: data['weather'][0]['icon'] ?? '',
      );
    } else {
     
      return null;
    }
  } catch (e) {
    
    return null;
  }
}
