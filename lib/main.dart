import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_map/screens/main_screen.dart';
import 'package:sky_map/services/device_orientation.dart';

void main() {

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => DeviceOrientation()),
    ],
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CelestialBodiesWidget(),
    ),
    ),
  );
}
