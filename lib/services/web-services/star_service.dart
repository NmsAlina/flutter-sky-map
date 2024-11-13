import 'dart:convert';
import 'dart:developer';

import 'url_fetch.dart';

import 'package:sky_map/models/constellation.dart';
import 'package:sky_map/models/star_model.dart';

const String starApiKey = "yUH6K6BmHzevYt3gmD/VKg==izmylLLm8E1ApeYT";

final Map<String, String> headers = {'X-api-key': starApiKey};

class ConstellationsService {
  
  final WebService _webService = WebService();

  Future<List<Constellation>> fetchConstellations(
      List<String> constellations, double deviceLat, double deviceLon) async {
    print('fetchConstellations method called'); // Confirm method call
    List<Constellation> finalConstellations = [];
    for (final constellationToFetch in constellations) {
      print('Fetching constellation: $constellationToFetch');
      Uri url = Uri.https('api.api-ninjas.com', '/v1/stars', {
        "constellation": constellationToFetch,
      });
      print('URL: $url');
      try {
        String? response = await _webService.fetchUrl(url, headers: headers);

        if (response != null) {
          print('Response: $response');
        } else {
          print('Response is null');
        }

        List<Star> constellationStars = [];
        if (response != null) {
          final constellationJson = json.decode(response);
          for (final starInConstellation in constellationJson) {
            Star star = Star.fromJson(starInConstellation);
            star.deviceLat = deviceLat;
            star.deviceLon = deviceLon;
            constellationStars.add(star);
          }
        } else {
          log('Error: No response received');
        }
        Constellation constellation = Constellation(stars: constellationStars);
        finalConstellations.add(constellation);
      } catch (e) {
        print('Exception caught: $e'); // Log exceptions
      }
    }
    return finalConstellations;
  }
}
