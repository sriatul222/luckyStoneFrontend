// Models for GET /api/v1/home (LuckyStoneBackend).
// ProductModel / CategoryModel are the same shapes the product list,
// product details, wishlist and cart APIs return, so they can be reused there.

import 'package:luckystone/extra/json_parser.dart';

class HomeModel {
  final List<MetalRateModel> metalRates;
  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<CollectionModel> collections;
  final List<ProductModel> featured;
  final List<ProductModel> newArrivals;

  const HomeModel({
    this.metalRates = const [],
    this.banners = const [],
    this.categories = const [],
    this.collections = const [],
    this.featured = const [],
    this.newArrivals = const [],
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      metalRates: parseList(json['metal_rates'], MetalRateModel.fromJson),
      banners: parseList(json['banners'], BannerModel.fromJson),
      categories: parseList(json['categories'], CategoryModel.fromJson),
      collections: parseList(json['collections'], CollectionModel.fromJson),
      featured: parseList(json['featured'], ProductModel.fromJson),
      newArrivals: parseList(json['new_arrivals'], ProductModel.fromJson),
    );
  }
}

class MetalRateModel {
  final int id;
  final String metal;
  final String purity;
  final double ratePerGram;

  const MetalRateModel({
    required this.id,
    required this.metal,
    required this.purity,
    required this.ratePerGram,
  });

  factory MetalRateModel.fromJson(Map<String, dynamic> json) {
    return MetalRateModel(
      id: parseInt(json['id']),
      metal: parseString(json['metal']),
      purity: parseString(json['purity']),
      ratePerGram: parseDouble(json['rate_per_gram']),
    );
  }

  String get label => '${metal[0].toUpperCase()}${metal.substring(1)} $purity';
}

class BannerModel {
  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String redirectType;
  final String redirectValue;

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.redirectType,
    required this.redirectValue,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: parseInt(json['id']),
      title: parseString(json['title']),
      subtitle: parseString(json['subtitle']),
      imageUrl: parseString(json['image_url']),
      redirectType: parseString(json['redirect_type']),
      redirectValue: parseString(json['redirect_value']),
    );
  }
}

class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String imageUrl;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      slug: parseString(json['slug']),
      imageUrl: parseString(json['image_url']),
    );
  }
}

class CollectionModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String imageUrl;

  const CollectionModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.imageUrl,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      slug: parseString(json['slug']),
      description: parseString(json['description']),
      imageUrl: parseString(json['image_url']),
    );
  }
}

class ProductModel {
  final int id;
  final String name;
  final String slug;
  final String sku;
  final String categoryName;
  final String metal;
  final String purity;
  final double netWeight;
  final String imageUrl;
  final double price;
  final double originalPrice;
  final double discountPercent;
  final double rating;
  final int reviewCount;
  final bool inStock;

  const ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.sku,
    required this.categoryName,
    required this.metal,
    required this.purity,
    required this.netWeight,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      slug: parseString(json['slug']),
      sku: parseString(json['sku']),
      categoryName: parseString(json['category_name']),
      metal: parseString(json['metal']),
      purity: parseString(json['purity']),
      netWeight: parseDouble(json['net_weight']),
      imageUrl: parseString(json['image_url']),
      price: parseDouble(json['price']),
      originalPrice: parseDouble(json['original_price']),
      discountPercent: parseDouble(json['discount_percent']),
      rating: parseDouble(json['rating']),
      reviewCount: parseInt(json['review_count']),
      inStock: json['in_stock'] == true,
    );
  }

  bool get hasDiscount => originalPrice > price;
}
