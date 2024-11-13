import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_map/models/constellation.dart';
import 'package:sky_map/models/planet_model.dart';
import 'package:sky_map/services/device_location.dart';
import 'package:sky_map/services/device_orientation.dart';
import 'package:sky_map/services/web-services/planet_service.dart';
import 'package:sky_map/services/web-services/star_service.dart';
import 'package:sky_map/painters/celestial_painter.dart';
import 'package:touchable/touchable.dart';


class CelestialBodiesWidget extends StatefulWidget {
  const CelestialBodiesWidget({super.key});

  @override
  _CelestialBodiesWidgetState createState() => _CelestialBodiesWidgetState();
}

class _CelestialBodiesWidgetState extends State<CelestialBodiesWidget> {
  final GeoLocator _geoLocator = GeoLocator();

  List<CelestialBody> celestialBodies = [];
  List<Constellation> constellations = [];
  double deviceLon = 0.0;
  double deviceLat = 0.0;
  double deviceAlt = 0.0;

  final SolarSystemBodiesService _celestialBodiesService = SolarSystemBodiesService();
  final ConstellationsService _constellationsService = ConstellationsService();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {  
    final orientation = Provider.of<DeviceOrientation>(context, listen: false);
    orientation.listenToAccelerometerEvents();
    orientation.listenToCompassEvents();
    });

    currentUserLocation();
  }

  void currentUserLocation() async{
    await _geoLocator.initialize();
    deviceLat = _geoLocator.latitude;
    deviceLon = _geoLocator.longitude;
    deviceAlt = _geoLocator.altitude;
    getConstellations();
    getBodies();

    setState(() {
      isLoading = false;
    });
  }

  void getBodies() async {
    celestialBodies = await _celestialBodiesService.fetchSolarSystemObjects(deviceLat, deviceLon, deviceAlt);
    setState(() {});
  }

  void getConstellations() async {
    constellations = await _constellationsService.fetchConstellations(
      // first line for northern hemisphere, existing in API-ninjas   'orion', 'cygnus', 'gemini',
      // second - equator 'auriga', 
      // third - southern hemisphere
      [
       'ursa minor', 'ursa major', 
       'scorpius', 
      //  'centaurus', 'libra'
       ], deviceLat, deviceLon);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    double screenHeight = MediaQuery.of(context).size.height - 20;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<DeviceOrientation>(builder: (context, orientation, child) {
      return Scaffold(
        body: CanvasTouchDetector(
          gesturesToOverride: const [GestureType.onTapDown],
          builder: (context) => CustomPaint(
            size: Size(screenWidth, screenHeight),
            painter: CelestialPainter(
              context: context,
              celestialBodies: celestialBodies,
              constellations: constellations,
              azimuth: orientation.deviceAzimuth,
              pitch: orientation.deviceInclination,
              onPlanetTap: (planet) {},
              onStarTap: (star, constellation, distance) {},
            ),
          ),
        ),
      );
    });
  }
}

