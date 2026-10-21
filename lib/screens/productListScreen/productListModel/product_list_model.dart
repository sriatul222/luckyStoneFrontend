// Models for GET /api/v1/products (paginated, with filters).
// Items are the same ProductModel the home API returns.

import 'package:equatable/equatable.dart';
import 'package:luckystone/extra/json_parser.dart';
import 'package:luckystone/screens/homeScreen/homeModel/home_model.dart';

/// Filters for the product list. Passed as the route argument when opening
/// RoutesName.productList, and kept in the cubit state.
class ProductListFilter extends Equatable {
  const ProductListFilter({
    this.title = '',
    this.q = '',
    this.category,
    this.collection,
    this.metal,
    this.purity,
    this.minPrice,
    this.maxPrice,
    this.featured,
    this.sort = 'newest',
    this.fromSearch = false,
  });

  // Screen heading, e.g. the category name. Not sent to the API.
  final String title;
  final String q;
  final String? category; // category slug, e.g. rings
  final String? collection; // collection slug, e.g. bridal
  final String? metal; // gold / silver / platinum
  final String? purity; // 22K, 18K, 925 ...
  final double? minPrice;
  final double? maxPrice;
  final bool? featured;
  final String sort;
  // Opened from the home search icon: focus the search box
  final bool fromSearch;

  static const Map<String, String> sortOptions = {
    'newest': 'Newest First',
    'popular': 'Popularity',
    'price_low_to_high': 'Price: Low to High',
    'price_high_to_low': 'Price: High to Low',
    'rating': 'Customer Rating',
  };

  static const List<String> metals = ['gold', 'silver', 'platinum'];
  static const List<String> purities = [
    '24K',
    '22K',
    '18K',
    '14K',
    '925',
    '950',
  ];

  /// Price ranges for the filter sheet as (label, min, max).
  static const List<(String, double?, double?)> priceRanges = [
    ('Under ₹10,000', null, 10000),
    ('₹10,000 - ₹25,000', 10000, 25000),
    ('₹25,000 - ₹50,000', 25000, 50000),
    ('₹50,000 - ₹1,00,000', 50000, 100000),
    ('Above ₹1,00,000', 100000, null),
  ];

  /// Number of filters picked in the filter sheet (for the badge).
  int get appliedFilterCount =>
      (metal != null ? 1 : 0) +
      (purity != null ? 1 : 0) +
      (minPrice != null || maxPrice != null ? 1 : 0);

  Map<String, dynamic> toQuery({required int page, int pageSize = 20}) {
    return {
      if (q.trim().isNotEmpty) 'q': q.trim(),
      'category': ?category,
      'collection': ?collection,
      'metal': ?metal,
      'purity': ?purity,
      'min_price': ?minPrice,
      'max_price': ?maxPrice,
      'featured': ?featured,
      'sort': sort,
      'page': page,
      'page_size': pageSize,
    };
  }

  ProductListFilter copyWith({String? q, String? sort}) {
    return ProductListFilter(
      title: title,
      q: q ?? this.q,
      category: category,
      collection: collection,
      metal: metal,
      purity: purity,
      minPrice: minPrice,
      maxPrice: maxPrice,
      featured: featured,
      sort: sort ?? this.sort,
      fromSearch: fromSearch,
    );
  }

  /// Replaces the filter-sheet values (null clears that filter).
  ProductListFilter withFilters({
    String? metal,
    String? purity,
    double? minPrice,
    double? maxPrice,
  }) {
    return ProductListFilter(
      title: title,
      q: q,
      category: category,
      collection: collection,
      metal: metal,
      purity: purity,
      minPrice: minPrice,
      maxPrice: maxPrice,
      featured: featured,
      sort: sort,
      fromSearch: fromSearch,
    );
  }

  @override
  List<Object?> get props => [
    title,
    q,
    category,
    collection,
    metal,
    purity,
    minPrice,
    maxPrice,
    featured,
    sort,
    fromSearch,
  ];
}

class ProductPageModel {
  final List<ProductModel> items;
  final int page;
  final int total;
  final int totalPages;

  const ProductPageModel({
    this.items = const [],
    this.page = 0,
    this.total = 0,
    this.totalPages = 0,
  });

  factory ProductPageModel.fromJson(Map<String, dynamic> json) {
    return ProductPageModel(
      items: parseList(json['items'], ProductModel.fromJson),
      page: parseInt(json['page']),
      total: parseInt(json['total']),
      totalPages: parseInt(json['total_pages']),
    );
  }
}
