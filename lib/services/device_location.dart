import 'package:location/location.dart';

class GeoLocator {
  double _currentLat = 0.0;
  double _currentLon = 0.0;
  double _currentAlt = 0.0;

  double get latitude => double.parse(_currentLat.toStringAsFixed(2));
  double get longitude => double.parse(_currentLon.toStringAsFixed(2));
  double get altitude => double.parse(_currentAlt.toStringAsFixed(2));

  Future<void> initialize() async {
    Location locationService = Location();
    bool isServiceActive;
    PermissionStatus permissionStatus;
    LocationData userLocation;

    // Check if the location service is enabled
    isServiceActive = await locationService.serviceEnabled();
    if (!isServiceActive) {
      // Request to enable the location service
      isServiceActive = await locationService.requestService();
      if (!isServiceActive) {
        return;
      }
    }

    // Check if the location permission is granted
    permissionStatus = await locationService.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      // Request location permission
      permissionStatus = await locationService.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    // Get the current location of the user
    userLocation = await locationService.getLocation();
    _currentLat = userLocation.latitude!;
    _currentLon = userLocation.longitude!;
    _currentAlt = userLocation.altitude!;
  }

  GeoLocator();
}
