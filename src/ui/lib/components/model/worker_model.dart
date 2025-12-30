class WorkerModel {
  final String id;
  final String fullName;
  final String username;
  final String phone;
  final int region;
  final String createdDate;
  final bool isActive;

  WorkerModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.phone,
    required this.region,
    required this.createdDate,
    required this.isActive,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      id: (json['id'] ?? '').toString(),
      fullName: (json['name'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      region: json['region'] is num ? (json['region'] as num).toInt() : 0,
      createdDate: _formatTimestamp(json['created_at']),
      isActive: json['is_active'] is bool ? json['is_active'] as bool : true,
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
    final formattedDate = '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year}';
    return formattedDate;
  }
}
