// Model for GET /api/v1/cart. Add / update / remove item APIs answer with
// the same shape, so the screen just replaces its cart with the response.

import 'package:luckystone/extra/json_parser.dart';
import 'package:luckystone/screens/homeScreen/homeModel/home_model.dart';

class CartModel {
  final List<CartItemModel> items;
  final CartSummaryModel summary;

  const CartModel({
    this.items = const [],
    this.summary = const CartSummaryModel(),
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: parseList(json['items'], CartItemModel.fromJson),
      summary: CartSummaryModel.fromJson(parseMap(json['summary'])),
    );
  }

  bool get isEmpty => items.isEmpty;

  /// Items that can not be ordered right now (out of stock / not enough).
  bool get hasUnavailableItems => items.any((item) => !item.isAvailable);
}

class CartItemModel {
  final int id;
  final ProductModel product;
  final String size;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final int availableStock;

  const CartItemModel({
    required this.id,
    required this.product,
    required this.size,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.availableStock,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: parseInt(json['id']),
      product: ProductModel.fromJson(parseMap(json['product'])),
      size: parseString(json['size']),
      quantity: parseInt(json['quantity'], defaultValue: 1),
      unitPrice: parseDouble(json['unit_price']),
      lineTotal: parseDouble(json['line_total']),
      availableStock: parseInt(json['available_stock']),
    );
  }

  bool get isAvailable => product.inStock && quantity <= availableStock;

  /// Backend allows 1-10 per item, and never more than the stock.
  int get maxQuantity => availableStock.clamp(1, 10);
}

class CartSummaryModel {
  final int itemCount;
  final int totalQuantity;
  final double subtotal;
  final double discount;
  final double gst;
  final double total;

  const CartSummaryModel({
    this.itemCount = 0,
    this.totalQuantity = 0,
    this.subtotal = 0,
    this.discount = 0,
    this.gst = 0,
    this.total = 0,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    return CartSummaryModel(
      itemCount: parseInt(json['item_count']),
      totalQuantity: parseInt(json['total_quantity']),
      subtotal: parseDouble(json['subtotal']),
      discount: parseDouble(json['discount']),
      gst: parseDouble(json['gst']),
      total: parseDouble(json['total']),
    );
  }
}
