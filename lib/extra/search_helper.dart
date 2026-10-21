import 'package:intl/intl.dart';

/// Shared matching for the list search boxes.
///
/// A row matches when any value shown on its card contains the typed text
/// (case-insensitive). Dates are compared in the same "dd MMM, yyyy" format
/// the cards display, so typing "Feb, 2026" finds what the user sees.
class SearchHelper {
  static final DateFormat _cardDateFormat = DateFormat('dd MMM, yyyy');

  static bool matches(String query, Iterable<Object?> cardValues) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    for (final value in cardValues) {
      if (value == null) continue;
      final text = value is DateTime
          ? _cardDateFormat.format(value.toLocal())
          : value.toString();
      if (text.toLowerCase().contains(q)) return true;
    }
    return false;
  }

  /// Value of an `other_property` entry by label (e.g. 'Proposal For').
  /// Every screen has its own OtherProperty class, all with label/value.
  static String? propertyValue(Iterable<dynamic>? properties, String label) {
    if (properties == null) return null;
    for (final property in properties) {
      if (property.label == label) return property.value?.toString();
    }
    return null;
  }

  /// Parses an API date string so it can be matched like a card date.
  static DateTime? parseDate(String? value) =>
      (value == null || value.isEmpty) ? null : DateTime.tryParse(value);
}
