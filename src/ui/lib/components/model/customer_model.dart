class CustomerModel {
  final String id;
  final String fullName;
  final String username;
  final String phone;
  final String createdDate;
  final int region;
  final bool isActive; // true: Hoạt động, false: Tạm dừng

  CustomerModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.phone,
    required this.createdDate,
    required this.region,
    required this.isActive,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: (json['id'] ?? '').toString(),
      fullName: (json['name'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      createdDate: _formatTimestamp(json['created_at']),
      region: json['region'] is num ? (json['region'] as num).toInt() : 0,
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
