double parseAscension(String value) {
  // Split the value into parts (hours, minutes, seconds)
  final parts = value.split(RegExp(r'[hms\s]')).where((s) => s.isNotEmpty).toList();

  if (parts.length != 3) {
    throw Exception('Invalid right ascension format: $value');
  }

  // Parse parts into integers and double
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final seconds = double.parse(parts[2]);

  // Convert to degrees
  final degrees = hours + minutes / 60 + seconds / 3600;
  return degrees;
}

double parseDeclination(String value) {
  // Split the value into parts (degrees, minutes, seconds)
  final parts = value.split(RegExp(r'[°′″]'));

  if (parts.length != 4) {
    throw Exception('Invalid declination format: $value');
  }

  // Parse parts into integers and double
  final degrees = int.parse(parts[0].trim());
  final minutes = int.parse(parts[1].trim());
  final seconds = double.parse(parts[2].trim());

  // Convert to decimal degrees
  return degrees + minutes / 60 + seconds / 3600;
}
