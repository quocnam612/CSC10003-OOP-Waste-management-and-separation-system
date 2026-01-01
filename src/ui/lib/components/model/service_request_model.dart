class ServiceRequestModel {
  final String id;
  final String district;
  final String address;
  final String note;
  final int region;
  final String createdAt;
  final String? userId;

  ServiceRequestModel({
    required this.id,
    required this.district,
    required this.address,
    required this.note,
    required this.region,
    required this.createdAt,
    this.userId,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      id: (json['id'] ?? '').toString(),
      district: (json['district'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      note: (json['note'] ?? '').toString(),
      region: json['region'] is num ? (json['region'] as num).toInt() : 0,
      createdAt: _formatTimestamp(json['created_at']),
      userId: json['user']?.toString(),
    );
  }

  static String _formatTimestamp(dynamic timestamp) {
    int? millis;
    if (timestamp is int) {
      millis = timestamp;
    } else if (timestamp is double) {
      millis = timestamp.toInt();
    } else if (timestamp is String) {
      millis = int.tryParse(timestamp);
    }

    if (millis == null || millis <= 0) return '--';

    final date = DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true).toLocal();
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    final formatted =
        '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year}';
    return formatted;
  }
}
