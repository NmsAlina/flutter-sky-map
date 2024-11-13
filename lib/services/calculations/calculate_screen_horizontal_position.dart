double calculatePlanetHorizontalPosition(
  double screenWidth,
  double cardinalDirectionDegrees,
  double azimuth,
) {
  var coefficient = screenWidth / 90;
  var width = cardinalDirectionDegrees + 90 - azimuth;
  if (width > 360) {
    width -= 360;
  } else if (width < 0) {
    width += 360;
  }
  var coorX = screenWidth - (coefficient * width);
  return coorX;
}


// double calculatePlanetHorizontalPosition(
//   double screenWidth,
//   double cardinalDirectionDegrees,
//   double azimuth,
// ) {
//   var coefficient = screenWidth / 90;
//   var width = cardinalDirectionDegrees + 90 - azimuth;

//   // Adjust the width to increase spacing
//   double scalingFactor = 0.8; // Increase to space out more, decrease to bring closer

//   width *= scalingFactor;

//   if (width > 360) {
//     width -= 360;
//   } else if (width < 0) {
//     width += 360;
//   }
//   var coorX = screenWidth - (coefficient * width);
//   return coorX;
// }
