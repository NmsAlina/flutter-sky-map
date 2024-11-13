double calculatePlanetVerticalPosition(
    double altitude, double inclination, double screenHeight) {
  inclination -= 90;
  if (inclination > 360) {
    inclination -= 360;
  } else if (inclination <= 0) {
    inclination += 360;
  }

  if (altitude < 0) {
    altitude += 360;
  }

  var coefficient = screenHeight / 90;
  num height;

  height = inclination + 90 - altitude;

  if (height >= 45 && height < 190) {
    height -= 45;
  } else if (altitude - inclination > 90) {
    height = (360 - 90 + inclination) + 90 - altitude + 45;
  } else if (inclination > altitude) {
    height -= 360;
    height -= 45;
  } else if (height < 45) {
    height = -1; // height = 0 ?
  }

  var coorY = coefficient * (height);

  return coorY;
}


// double calculatePlanetVerticalPosition(
//     double altitude, double inclination, double screenHeight) {
//   inclination -= 90;
//   if (inclination > 360) {
//     inclination -= 360;
//   } else if (inclination <= 0) {
//     inclination += 360;
//   }

//   if (altitude < 0) {
//     altitude += 360;
//   }

//   var coefficient = screenHeight / 90;
//   num height;

//   height = inclination + 90 - altitude;

//   // Apply scaling to height calculation
//   double scalingFactor = 2.0; // Increase to space out more, decrease to bring closer
//   height *= scalingFactor;

//   if (height >= 45 && height < 190) {
//     height -= 45;
//   } else if (altitude - inclination > 90) {
//     height = (360 - 90 + inclination) + 90 - altitude + 45;
//   } else if (inclination > altitude) {
//     height -= 360;
//     height -= 45;
//   } else if (height < 45) {
//     height = -1; // height = 0 ?
//   }

//   var coorY = coefficient * (height);

//   return coorY;
// }
