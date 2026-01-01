class RouteModel {
  final String id;
  final String district;
  final String shift;
  final int team;
  final List<String> stops;
  final int region;

  const RouteModel({
    required this.id,
    required this.district,
    required this.shift,
    required this.team,
    required this.stops,
    required this.region,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final stopsRaw = json['route'];
    final parsedStops = <String>[];
    if (stopsRaw is Iterable) {
      for (final value in stopsRaw) {
        if (value == null) continue;
        parsedStops.add(value.toString());
      }
    } else if (stopsRaw is String && stopsRaw.trim().isNotEmpty) {
      parsedStops.add(stopsRaw.trim());
    }

    return RouteModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      district: (json['district'] ?? '').toString(),
      shift: (json['shift'] ?? '').toString(),
      team: json['team'] is num ? (json['team'] as num).toInt() : 0,
      stops: parsedStops,
      region: json['region'] is num ? (json['region'] as num).toInt() : 0,
    );
  }
}

class RouteCreationData {
  final String district;
  final String shift;
  final int team;
  final List<String> stops;

  const RouteCreationData({
    required this.district,
    required this.shift,
    required this.team,
    required this.stops,
  });
}
