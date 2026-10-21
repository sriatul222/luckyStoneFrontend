import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class MyUtils {
  static final NumberFormat _rupee = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );
  static final NumberFormat _rupeeExact = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );
  static final DateFormat _dateTime = DateFormat('dd MMM yyyy, hh:mm a');

  static Future<void> showPrint(String msg) async {
    log(msg);
  }

  static Future<void> printLog(String msg) async {
    if (kDebugMode) {
      log(msg);
      // print(msg);
    }
  }

  /// ₹72,599 - for product cards and lists.
  static String price(num value) => _rupee.format(value);

  /// ₹72,599.42 - for price breakup, cart and order totals, so the rows
  /// add up exactly.
  static String exactPrice(num value) => _rupeeExact.format(value);

  static String dateTime(DateTime? value) =>
      value == null ? '' : _dateTime.format(value);
}
