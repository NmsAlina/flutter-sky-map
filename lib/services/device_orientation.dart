import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:sky_map/services/throttler.dart';

//device orientation state
class DeviceOrientation extends ChangeNotifier {
  double _heading = 0.0;
  double _inclination = 0.0;

  // Getter for device azimuth (heading), rounded to two decimal places
  double get deviceAzimuth => double.parse(_heading.toStringAsFixed(2));

  // Getter for device inclination, rounded to two decimal places
  double get deviceInclination => double.parse(_inclination.toStringAsFixed(2));
  
  Throttler throttler = Throttler(
      throttleGapInMillis:
          100); //added throttle to reduce amount of data receiving from sensors; not in use atm;
  
  DeviceOrientation();
  void listenToCompassEvents() {
    FlutterCompass.events?.listen((event) {
      _heading = sanitizeHeading(event.heading);
      notifyListeners();
    });
  }

  void listenToAccelerometerEvents() {
    accelerometerEvents.listen((event) {
      List<double> g = [event.x, event.y, event.z];
      double norm = sqrt(g[0] * g[0] + g[1] * g[1] + g[2] * g[2]);
      g[0] /= norm;
      g[1] /= norm;
      g[2] /= norm;
      var inclination = (acos(g[2]) * 180 / pi);
      if (g[1] < 0) {
        inclination = 360 - inclination;
      }
      _inclination = inclination;
      // notifyListeners();

      throttler.run(() => notifyListeners());
    });
  }
}

double sanitizeHeading(double? hd) {
  if (hd == null) return 0;
  if (hd < 0) return 360 + hd;
  if (hd > 0) return hd;
  return hd;
}
