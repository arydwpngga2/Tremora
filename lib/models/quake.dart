class Quake {
  final DateTime time; // UTC
  final double lat;
  final double lon;
  final double magnitude;
  final double depthKm;
  final String region;
  final String potential;
  final String felt;
  final String shakemap;

  const Quake({
    required this.time,
    required this.lat,
    required this.lon,
    required this.magnitude,
    required this.depthKm,
    required this.region,
    required this.potential,
    required this.felt,
    required this.shakemap,
  });

  String get id => '${time.millisecondsSinceEpoch}_${lat}_$lon';

  factory Quake.fromJson(Map<String, dynamic> j) {
    final coords = (j['Coordinates'] as String).split(',');
    final depthText = RegExp(r'[\d.]+').stringMatch('${j['Kedalaman']}');

    return Quake(
      time: DateTime.parse(j['DateTime'] as String).toUtc(),
      lat: double.parse(coords[0].trim()),
      lon: double.parse(coords[1].trim()),
      magnitude: double.parse('${j['Magnitude']}'),
      depthKm: double.tryParse(depthText ?? '') ?? 0,
      region: j['Wilayah'] as String? ?? '-',
      potential: j['Potensi'] as String? ?? '',
      felt: j['Dirasakan'] as String? ?? '',
      shakemap: j['Shakemap'] as String? ?? '',
    );
  }
}
