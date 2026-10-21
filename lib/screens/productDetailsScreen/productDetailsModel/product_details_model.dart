// Models for GET /api/v1/products/{id} and /products/{id}/reviews.
// The details JSON is a ProductModel (card) plus extra fields, so the card
// part is parsed with the same ProductModel the home and list screens use.

import 'package:luckystone/extra/json_parser.dart';
import 'package:luckystone/screens/homeScreen/homeModel/home_model.dart';

class ProductDetailsModel {
  final ProductModel product;
  final String description;
  final String collectionName;
  final List<String> imageUrls;
  final String gender;
  final String occasion;
  final List<String> sizes;
  final double grossWeight;
  final String stoneType;
  final double stoneWeightCarat;
  final String stoneQuality;
  final double makingChargePercent;
  final int stock;
  final bool isWishlisted;
  final PriceBreakupModel priceBreakup;

  const ProductDetailsModel({
    required this.product,
    required this.description,
    required this.collectionName,
    required this.imageUrls,
    required this.gender,
    required this.occasion,
    required this.sizes,
    required this.grossWeight,
    required this.stoneType,
    required this.stoneWeightCarat,
    required this.stoneQuality,
    required this.makingChargePercent,
    required this.stock,
    required this.isWishlisted,
    required this.priceBreakup,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      product: ProductModel.fromJson(json),
      description: parseString(json['description']),
      collectionName: parseString(json['collection_name']),
      imageUrls: _stringList(json['image_urls']),
      gender: parseString(json['gender']),
      occasion: parseString(json['occasion']),
      sizes: _stringList(json['sizes']),
      grossWeight: parseDouble(json['gross_weight']),
      stoneType: parseString(json['stone_type']),
      stoneWeightCarat: parseDouble(json['stone_weight_carat']),
      stoneQuality: parseString(json['stone_quality']),
      makingChargePercent: parseDouble(json['making_charge_percent']),
      stock: parseInt(json['stock']),
      isWishlisted: json['is_wishlisted'] == true,
      priceBreakup: PriceBreakupModel.fromJson(parseMap(json['price_breakup'])),
    );
  }

  /// Images for the carousel; falls back to the card image.
  List<String> get images {
    final urls = imageUrls.where((url) => url.isNotEmpty).toList();
    if (urls.isNotEmpty) return urls;
    return product.imageUrl.isNotEmpty ? [product.imageUrl] : [];
  }

  bool get needsSize => sizes.isNotEmpty;

  static List<String> _stringList(dynamic value) {
    if (value is! List) return [];
    return value.map((item) => item.toString()).toList();
  }
}

class PriceBreakupModel {
  final double metalRate;
  final double metalValue;
  final double makingCharges;
  final double makingDiscount;
  final double stoneValue;
  final double subtotal;
  final double gstPercent;
  final double gst;
  final double total;

  const PriceBreakupModel({
    required this.metalRate,
    required this.metalValue,
    required this.makingCharges,
    required this.makingDiscount,
    required this.stoneValue,
    required this.subtotal,
    required this.gstPercent,
    required this.gst,
    required this.total,
  });

  factory PriceBreakupModel.fromJson(Map<String, dynamic> json) {
    return PriceBreakupModel(
      metalRate: parseDouble(json['metal_rate']),
      metalValue: parseDouble(json['metal_value']),
      makingCharges: parseDouble(json['making_charges']),
      makingDiscount: parseDouble(json['making_discount']),
      stoneValue: parseDouble(json['stone_value']),
      subtotal: parseDouble(json['subtotal']),
      gstPercent: parseDouble(json['gst_percent']),
      gst: parseDouble(json['gst']),
      total: parseDouble(json['total']),
    );
  }
}

class ReviewModel {
  final int id;
  final String userName;
  final int rating;
  final String comment;
  final DateTime? createdAt;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: parseInt(json['id']),
      userName: parseString(json['user_name']),
      rating: parseInt(json['rating']),
      comment: parseString(json['comment']),
      createdAt: parseDate(json['created_at']),
    );
  }
}
