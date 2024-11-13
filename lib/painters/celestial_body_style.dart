import 'package:flutter/material.dart';
import 'package:sky_map/models/planet_model.dart';

void setCelestialBodyProperties(CelestialBody body, Paint paint) {
  double opacity = body.altitude < 0 ? 0.2 : 1.0;
  double size;

  switch (body.name) {
    case 'Sun':
      paint.color = Colors.yellow.withOpacity(opacity);
      size = 30.0;
      break;
    case 'Mercury':
      paint.color = const Color.fromARGB(255, 172, 202, 201);
      size = 5.0;
      break;
    case 'Venus':
      paint.color = const Color.fromARGB(255, 241, 225, 131);
      size = 8.0;
      break;
    case 'Moon':
      paint.color = const Color.fromARGB(255, 124, 138, 143);
      size = 7.0; 
      break;
    case 'Mars':
      paint.color = const Color.fromARGB(255, 213, 31, 31);
      size = 7.0; 
      break;
    case 'Jupiter':
      paint.color = const Color.fromARGB(255, 184, 119, 0);
      size = 15.0;
      break;
    case 'Saturn':
      paint.color = const Color.fromARGB(226, 191, 125, 0);
      size = 13.0;
    case 'Uranus':
      paint.color = const Color.fromARGB(255, 67, 255, 255);
      size = 10.0;
      break;
    case 'Neptune':
      paint.color = const Color.fromARGB(255, 63, 84, 186);
      size = 10.0;
      break;
    default:
      const defaultColor = Colors.deepPurple;
      paint.color = defaultColor;
      size = 6.0;
      break;
  }
  paint.strokeWidth = size;
}
