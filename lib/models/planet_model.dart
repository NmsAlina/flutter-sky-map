import 'package:sky_map/services/calculations/calculate_screen_horizontal_position.dart';
import 'package:sky_map/services/calculations/calculate_screen_vertical_position.dart';

import 'user_model.dart';

class CelestialBody {
  final String id;
  final String name;
  final double altitude;
  final double azimuth;

  CelestialBody({
    required this.id,
    required this.name,
    required this.altitude,
    required this.azimuth,
  });

  List<double> onScreenCoordinates(UserPosition user, double screenWidth,
      double screenHeight, double bodyAzimuth, double bodyAltitude) {
    var onScreenX = calculatePlanetHorizontalPosition(
        screenWidth, user.azimuth, bodyAzimuth);
    var onScreenY =
        calculatePlanetVerticalPosition(bodyAltitude, user.pitch, screenHeight);

    return [onScreenX, onScreenY];
  }

  factory CelestialBody.fromJson(Map<String, dynamic> json, int index) {
    final data = json['data']['rows'][index];

    // Extract ID and name
    final id = data['body']['id'];
    final name = data['body']['name'];

    // Extract coordinates if available
    final horizontalPosition = data['positions'][0]['position']['horizontal'];
    final altitudeDegrees = double.parse(horizontalPosition['altitude']['degrees']);
    final azimuthDegrees = double.parse(horizontalPosition['azimuth']['degrees']);

    return CelestialBody(
      id: id,
      name: name,
      altitude: altitudeDegrees,
      azimuth: azimuthDegrees,
    );
  }
}
