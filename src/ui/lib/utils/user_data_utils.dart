class UserDataUtils {
  static String stringField(Map<String, dynamic> data, String key,
      {String fallback = ''}) {
    final value = data[key];
    if (value == null) return fallback;
    if (value is String) return value;
    if (value is num) return value.toString();
    if (value is Map<String, dynamic>) {
      if (value.containsKey(r'$numberInt')) {
        return value[r'$numberInt'].toString();
      }
      if (value.containsKey(r'$numberLong')) {
        return value[r'$numberLong'].toString();
      }
      if (value.containsKey(r'$oid')) {
        return value[r'$oid'].toString();
      }
    }
    return value.toString();
  }

  static int intField(Map<String, dynamic> data, String key,
      {int fallback = 0}) {
    final value = data[key];
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    if (value is Map<String, dynamic>) {
      if (value.containsKey(r'$numberInt')) {
        return int.tryParse(value[r'$numberInt'].toString()) ?? fallback;
      }
      if (value.containsKey(r'$numberLong')) {
        return int.tryParse(value[r'$numberLong'].toString()) ?? fallback;
      }
    }
    return fallback;
  }
}
