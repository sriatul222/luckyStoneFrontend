import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/screens/homeScreen/homeModel/home_model.dart';
import 'package:luckystone/screens/productListScreen/productListModel/product_list_model.dart';

class ProductListState extends Equatable {
  const ProductListState({
    this.status = FormzStatus.pure,
    this.exceptionError,
    this.filter = const ProductListFilter(),
    this.products = const [],
    this.page = 0,
    this.totalPages = 0,
    this.total = 0,
    this.isLoadingMore = false,
  });

  final FormzStatus status; // first page
  final String? exceptionError;
  final ProductListFilter filter;
  final List<ProductModel> products;
  final int page;
  final int totalPages;
  final int total;
  final bool isLoadingMore; // next pages

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [
    status,
    exceptionError,
    filter,
    products,
    page,
    totalPages,
    total,
    isLoadingMore,
  ];

  ProductListState copyWith({
    FormzStatus? status,
    String? exceptionError,
    ProductListFilter? filter,
    List<ProductModel>? products,
    int? page,
    int? totalPages,
    int? total,
    bool? isLoadingMore,
  }) {
    return ProductListState(
      status: status ?? this.status,
      exceptionError: exceptionError ?? this.exceptionError,
      filter: filter ?? this.filter,
      products: products ?? this.products,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
