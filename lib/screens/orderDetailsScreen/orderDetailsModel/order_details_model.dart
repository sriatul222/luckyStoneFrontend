// Model for GET /api/v1/orders/{id}. POST /orders (place order) and
// POST /orders/{id}/cancel answer with the same shape.

import 'package:luckystone/extra/json_parser.dart';
import 'package:luckystone/screens/addressScreen/addressModel/address_model.dart';
import 'package:luckystone/screens/myOrdersScreen/myOrdersModel/my_orders_model.dart';

class OrderDetailsModel {
  final OrderModel order;
  final AddressModel shippingAddress;
  final List<OrderItemModel> items;

  const OrderDetailsModel({
    required this.order,
    required this.shippingAddress,
    required this.items,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      order: OrderModel.fromJson(json),
      shippingAddress: AddressModel.fromJson(
        parseMap(json['shipping_address']),
      ),
      items: parseList(json['items'], OrderItemModel.fromJson),
    );
  }
}

class OrderItemModel {
  final int id;
  final int? productId; // null if the product was deleted later
  final String productName;
  final String sku;
  final String imageUrl;
  final String metal;
  final String purity;
  final double netWeight;
  final String size;
  final int quantity;
  final double unitPrice;
  final double lineTotal;

  const OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.sku,
    required this.imageUrl,
    required this.metal,
    required this.purity,
    required this.netWeight,
    required this.size,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: parseInt(json['id']),
      productId: json['product_id'] == null
          ? null
          : parseInt(json['product_id']),
      productName: parseString(json['product_name']),
      sku: parseString(json['sku']),
      imageUrl: parseString(json['image_url']),
      metal: parseString(json['metal']),
      purity: parseString(json['purity']),
      netWeight: parseDouble(json['net_weight']),
      size: parseString(json['size']),
      quantity: parseInt(json['quantity'], defaultValue: 1),
      unitPrice: parseDouble(json['unit_price']),
      lineTotal: parseDouble(json['line_total']),
    );
  }
}
