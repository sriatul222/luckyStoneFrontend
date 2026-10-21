// Safe readers for LuckyStoneBackend JSON, shared by every screen's model.
// Numbers can arrive as int, double or string, and lists/objects can be null.

List<T> parseList<T>(dynamic value, T Function(Map<String, dynamic>) fromJson) {
  if (value is! List) return [];
  return value.whereType<Map<String, dynamic>>().map(fromJson).toList();
}

Map<String, dynamic> parseMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  return const {};
}

int parseInt(dynamic value, {int defaultValue = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

double parseDouble(dynamic value, {double defaultValue = 0}) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? defaultValue;
  return defaultValue;
}

String parseString(dynamic value, {String defaultValue = ''}) {
  if (value == null) return defaultValue;
  return value.toString();
}

/// Backend sends ISO-8601 with timezone; shown in the phone's local time.
DateTime? parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString())?.toLocal();
}
