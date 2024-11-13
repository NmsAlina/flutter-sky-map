import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sky_map/models/constellation.dart';
import 'package:sky_map/models/planet_model.dart';
import 'package:sky_map/models/user_model.dart';
import 'package:sky_map/painters/celestial_body_style.dart';
import 'package:touchable/touchable.dart';

class CelestialPainter extends CustomPainter {
  final BuildContext context;
  Function(String) onPlanetTap;
  Function(String, String, String) onStarTap; // Updated to include constellation
  final List<Constellation> constellations;
  final List<CelestialBody> celestialBodies;
  final double azimuth;
  final double pitch;

  CelestialPainter({
    required this.context,
    required this.constellations,
    required this.celestialBodies,
    required this.onPlanetTap,
    required this.onStarTap,
    required this.azimuth,
    required this.pitch,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    UserPosition userPosition = UserPosition(azimuth: azimuth, pitch: pitch);
    var myCanvas = TouchyCanvas(context, canvas);
    canvas.drawRect(
      Rect.fromPoints(const Offset(0, 0), Offset(screenWidth, screenHeight)),
      Paint()..color = Colors.black,
    );

    // Paint planets
    for (CelestialBody body in celestialBodies) {
      List<double> coordinates = body.onScreenCoordinates(
        userPosition,
        screenWidth,
        screenHeight,
        body.azimuth,
        body.altitude,
      );

      Paint paint = Paint();
      setCelestialBodyProperties(body, paint);

      // Draw the halo for the Sun
   if (body.name == 'Sun') {
        double haloSize = 200.0; // Adjust halo size as needed
        Paint haloPaint = Paint()
          ..shader = RadialGradient(
            colors: [Colors.yellow.withOpacity(0.8), Colors.transparent],
            stops: [0.0, 1.0],
          ).createShader(
            Rect.fromCircle(
              center: Offset(coordinates[0], coordinates[1]),
              radius: haloSize,
            ),
          )
          ..style = PaintingStyle.fill;

        myCanvas.drawCircle(
          Offset(coordinates[0], coordinates[1]),
          haloSize,
          haloPaint,
        );
      }
      // Draw the celestial body
      myCanvas.drawCircle(
        Offset(coordinates[0], coordinates[1]),
        paint.strokeWidth,
        paint,
        onTapDown: (_) {
          log("You clicked ${body.name}");
          _showCenteredDialog(
            content: 'Planet: ${body.name}\nAzimuth: ${azimuth.toStringAsFixed(2)}°\nPitch: ${pitch.toStringAsFixed(2)}°',
          );
          onPlanetTap(body.name);
        },
      );

      // Draw name labels
      final textPainter = TextPainter(
        text: TextSpan(
          text: body.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(coordinates[0] - textPainter.width / 2, coordinates[1] + 10),
      );
    }

    // Paint constellations
    for (final constellation in constellations) {
      // Draw lines between stars to represent constellations
      for (int i = 0; i < constellation.stars.length - 1; i++) {
        final star1 = constellation.stars[i];
        final star2 = constellation.stars[i + 1];

        List<double> position1 = star1.onScreenCoordinates(
          userPosition,
          screenWidth,
          screenHeight,
          star1.starPosition[1],
          star1.starPosition[0],
        );

        List<double> position2 = star2.onScreenCoordinates(
          userPosition,
          screenWidth,
          screenHeight,
          star2.starPosition[1],
          star2.starPosition[0],
        );

        myCanvas.drawLine(
          Offset(position1[0], position1[1]),
          Offset(position2[0], position2[1]),
          Paint()..color = Colors.blueAccent.withOpacity(0.5),
        );
      }

      // Draw the stars
      for (final star in constellation.stars) {
        List<double> starPosition = star.starPosition;

        double starAltitude = starPosition[0];
        double starAzimuth = starPosition[1];

        List<double> screenCoordinates = star.onScreenCoordinates(
          userPosition,
          screenWidth,
          screenHeight,
          starAzimuth,
          starAltitude,
        );

        myCanvas.drawCircle(
          Offset(screenCoordinates[0], screenCoordinates[1]),
          4,
          Paint()..color = Colors.white,
          onTapDown: (_) {
            log("You clicked ${star.name}");
            _showCenteredDialog(
                content: 'Star: ${star.name}\nConstellation: ${star.constellationName}\nDistance: ${star.distance} light years');
            onStarTap(star.name, star.constellationName, star.distance);
          },
        );
      }
    }
  }

  void _showCenteredDialog({required String content}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
