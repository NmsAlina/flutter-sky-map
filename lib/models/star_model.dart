import 'dart:math';
import 'package:sky_map/models/user_model.dart';
import 'package:sky_map/services/calculations/calculate_stars.dart';
import 'package:vector_math/vector_math_64.dart';


class Star {
  final String name;
  final String constellationName;
  final String distance;
  final double ra;
  final double dec;
  final double magnitude;
  double deviceLat;
  double deviceLon;

  List<double> get starPosition {
    return _convertEquatorialToHorizontal();
  }

  Star({
    required this.name,
    required this.constellationName,
    required this.distance,
    required this.ra,
    required this.dec,
    required this.deviceLat,
    required this.deviceLon,
    required this.magnitude,
  });

  factory Star.fromJson(Map<String, dynamic> json) {
    final double declination = parseDeclination(json['declination']);
    final double ascension = parseAscension(json['right_ascension']);
    final magnitude = double.parse(json['apparent_magnitude']);
    return Star(
      name: json['name'],
      constellationName: json['constellation'],
      distance: json['distance_light_year'],
      ra: ascension,
      dec: declination,
      deviceLat: 0.0,
      deviceLon: 0.0,
      magnitude: magnitude,
    );
  }

  List<double> _convertEquatorialToHorizontal() {
    final double j2000 = getJ2000();
    DateTime dateTimeNow = DateTime.now().toUtc();

    final double lst = getLocalSiderealTime(j2000, deviceLon, dateTimeNow);
    final double hourAngle = getHourAngle(lst, ra * 15);
    final double altitude = calcAlt(dec, deviceLat, hourAngle);
    final double azimuth = calcAzim(dec, altitude, deviceLat, hourAngle);

    return [altitude, azimuth];
  }

  List<double> onScreenCoordinates(UserPosition user, double screenWidth,
      double screenHeight, double bodyAzimuth, double bodyAltitude) {
    var onScreenX = calculatePlanetHorizontalPosition(
        screenWidth, user.azimuth, bodyAzimuth);
    var onScreenY =
        calculatePlanetVerticalPosition(bodyAltitude, user.pitch, screenHeight);

    return [onScreenX, onScreenY];
  }
}

double getJ2000() {
  final jan12000 = DateTime.utc(2000, 1, 1, 12, 0, 0);
  final now = DateTime.now().toUtc();
  final double j2000 = now.difference(jan12000).inDays.toDouble();
  return j2000;
}

double getLocalSiderealTime(double jd, double longitude, DateTime time) {
  double ut = time.hour + (time.minute / 60);

  double lst = 100.4606184 + (0.985647366 * jd) + longitude + (15 * ut);
  if (lst > 360) {
    lst = lst - ((lst / 360).floor() * 360);
  } else if (lst < 0) {
    while (lst < 0) {
      lst += 360;
    }
  }
  return lst;
}

double getHourAngle(double lst, double ra) {
  var ha = lst - ra;
  return ha;
}

double calcAzim(double decDegr, double altDegr, double latDegr, double haDegr) {
  double decRad = radians(decDegr);
  double altRad = radians(altDegr);
  double latRad = radians(latDegr);
  double haRad = radians(haDegr);
  double cosA =
      (sin(decRad) - sin(altRad) * sin(latRad)) / (cos(altRad) * cos(latRad));
  double azim = acos(cosA);
  double azimDegr = azim * 180 / pi;
  if (sin(haRad) > 0) {
    azimDegr = 360 - azimDegr;
  }
  return azimDegr;
}

double calcAlt(double dec, double lat, double ha) {
  double decRad = radians(dec);
  double latRad = radians(lat);
  double haRad = radians(ha);
  double sinAlt =
      (sin(decRad) * sin(latRad)) + (cos(decRad) * cos(latRad) * cos(haRad));
  double alt = asin(sinAlt);
  double altDegr = alt * 180 / pi;
  return altDegr;
}



double calculatePlanetHorizontalPosition(
    double screenWidth, double userAzimuth, double bodyAzimuth) {
  // Example calculation, replace with actual logic
  return (bodyAzimuth - userAzimuth) * (screenWidth / 360);
}

double calculatePlanetVerticalPosition(
    double bodyAltitude, double userPitch, double screenHeight) {
  // Example calculation, replace with actual logic
  return (90 - bodyAltitude + userPitch) * (screenHeight / 180);
}

//  // Calculates the horizontal position of the star on the screen
//   double calculatePlanetHorizontalPosition(
//       double screenWidth, double userAzimuth, double bodyAzimuth) {
//     double scalingFactor = 1.9; // Adjust this factor as needed to space out the stars
//     return (bodyAzimuth - userAzimuth) * (screenWidth / 360) * scalingFactor;
//   }

//   // Calculates the vertical position of the star on the screen
//   double calculatePlanetVerticalPosition(
//       double bodyAltitude, double userPitch, double screenHeight) {
//     double scalingFactor = 1.9; // Adjust this factor as needed to space out the stars
//     return (90 - bodyAltitude + userPitch) * (screenHeight / 180) * scalingFactor;
//   }
