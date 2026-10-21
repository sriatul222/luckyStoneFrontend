// Models for GET /api/v1/orders (paginated order summaries).

import 'package:luckystone/extra/json_parser.dart';

class OrderModel {
  final int id;
  final String orderNumber;
  final String status; // PLACED / CONFIRMED / SHIPPED / DELIVERED / CANCELLED
  final String paymentMethod;
  final String paymentStatus;
  final int itemCount;
  final double subtotal;
  final double discount;
  final double gst;
  final double total;
  final DateTime? createdAt;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.itemCount,
    required this.subtotal,
    required this.discount,
    required this.gst,
    required this.total,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: parseInt(json['id']),
      orderNumber: parseString(json['order_number']),
      status: parseString(json['status']),
      paymentMethod: parseString(json['payment_method']),
      paymentStatus: parseString(json['payment_status']),
      itemCount: parseInt(json['item_count']),
      subtotal: parseDouble(json['subtotal']),
      discount: parseDouble(json['discount']),
      gst: parseDouble(json['gst']),
      total: parseDouble(json['total']),
      createdAt: parseDate(json['created_at']),
    );
  }

  /// Backend allows cancelling only before the order is shipped.
  bool get canCancel => status == 'PLACED' || status == 'CONFIRMED';

  String get paymentLabel =>
      paymentMethod == 'COD' ? 'Cash on Delivery' : paymentMethod;
}

class OrderPageModel {
  final List<OrderModel> items;
  final int page;
  final int totalPages;

  const OrderPageModel({
    this.items = const [],
    this.page = 0,
    this.totalPages = 0,
  });

  factory OrderPageModel.fromJson(Map<String, dynamic> json) {
    return OrderPageModel(
      items: parseList(json['items'], OrderModel.fromJson),
      page: parseInt(json['page']),
      totalPages: parseInt(json['total_pages']),
    );
  }
}
