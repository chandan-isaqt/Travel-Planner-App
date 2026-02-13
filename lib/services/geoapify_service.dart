import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:traveling_app/model/placeModel.dart';

class GeoapifyService {
  final String apiKey = 'a3246b5f3e6341669e4833af6ecf95c5';

  Future<Map<String, double>?> searchPlace(String text) async {
    try {
      final uri = Uri.https(
        'api.geoapify.com',
        '/v1/geocode/search',
        {
          'text': text,
          'apiKey': apiKey,
        },
      );

      final response =
          await http.get(uri).timeout(const Duration(seconds: 15));

      log("Search Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List features = data['features'] ?? [];

        if (features.isNotEmpty) {
          final coordinates =
              features[0]['geometry']['coordinates'];

          final lon = coordinates[0];
          final lat = coordinates[1];

          return {
            'lat': (lat as num).toDouble(),
            'lon': (lon as num).toDouble(),
          };
        }
      }
    } catch (e) {
      log("Search API Exception: $e");
    }

    return null;
  }

  Future<List<Place>> getTouristSpots(
    double lat,
    double lon, {
    int limit = 10,
  }) async {
    try {
      final uri = Uri.https(
        'api.geoapify.com',
        '/v2/places',
        {
          'categories': 'tourism.sights',
          'filter': 'circle:$lon,$lat,5000',
          'limit': limit.toString(),
          'apiKey': apiKey,
        },
      );

      final response =
          await http.get(uri).timeout(const Duration(seconds: 15));

      log("Places Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List results = data['features'] ?? [];

        return results
            .map((e) => Place.fromJson(e))
            .toList();
      }
    } catch (e) {
      log("Places API Exception: $e");
    }

    return [];
  }
}
