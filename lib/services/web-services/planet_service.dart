import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_map/models/planet_model.dart';

import 'url_fetch.dart';


//get solar system bodies excluding Earth
class SolarSystemBodiesService {
  final WebService _webService = WebService();

  Future<List<CelestialBody>> fetchSolarSystemObjects(
      double deviceLat, double deviceLon, double deviceAlt) async {

    try{
      List<CelestialBody> celestialBodiesExcludingEarth = [];
      final currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      Uri url = Uri.https('api.astronomyapi.com', '/api/v2/bodies/positions', {
        "longitude": deviceLon.toString(),
        "latitude": deviceLat.toString(),
        "elevation": deviceAlt.toString(),
        "from_date": currentDate,
        "to_date": currentDate,
        "time": currentTime,
        "output": "rows",
      });

      const String applicationId = '4a07bfdc-5fd1-498a-ba19-dcebe10ef9dc';
      const String applicationSecret = '88a6fefceaf7e2042fbcf882e044b9677d5f735a205f34d4c66a0898efa34a67e6e754aa6faf263f7e2733c5bd79beab59c7bfbfda700c089a2345946422cccd1f226975f732b22a17d520ccdba5ed7e6cc222d8fedbf19ff24b253b9292f0ef53db334457b7183167993bfc94f2a6ac';
      String authString = base64Encode(utf8.encode('$applicationId:$applicationSecret'));

      var headers = {"authorization": 'Basic $authString'};

      String? response = await _webService.fetchUrl(url, headers: headers);

      if (response != null) {
        final jsonData = json.decode(response);
        for (int i = 0; i < 11; i++) {
          final body = CelestialBody.fromJson(jsonData, i);
          if (body.id == 'earth') continue;
          celestialBodiesExcludingEarth.add(body);
        }
      } else {
        debugPrint("SolarSystemBodiesService: No response");
      }

      return celestialBodiesExcludingEarth;

    } catch (e){
      debugPrint("Error fetching solar system objects: $e");
      return[];
    }
  }
}
