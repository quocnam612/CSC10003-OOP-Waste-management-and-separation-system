class ReportModel {
  final String id;
  final String title;
  final String content;
  final int type;
  final String typeLabel;
  final bool resolved;
  final String createdDate;

  ReportModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.typeLabel,
    required this.resolved,
    required this.createdDate,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      type: json['type'] is num ? (json['type'] as num).toInt() : 0,
      typeLabel: _typeToLabel(json['type']),
      resolved: json['resolved'] is bool ? json['resolved'] as bool : false,
      createdDate: _formatTimestamp(json['created_at']),
    );
  }

  static String _typeToLabel(dynamic rawType) {
    int index = 0;
    if (rawType is int) {
      index = rawType;
    } else if (rawType is double) {
      index = rawType.toInt();
    } else if (rawType is String) {
      index = int.tryParse(rawType) ?? 0;
    }

    switch (index) {
      case 1:
        return 'Rác chưa được thu gom';
      case 2:
        return 'Thái độ nhân viên';
      case 3:
        return 'Yêu cầu dịch vụ thêm';
      default:
        return 'Khác';
    }
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
    final formattedTime = '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
    return '$formattedDate $formattedTime';
  }
}
