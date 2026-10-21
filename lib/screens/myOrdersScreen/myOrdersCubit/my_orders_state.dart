import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/screens/myOrdersScreen/myOrdersModel/my_orders_model.dart';

class MyOrdersState extends Equatable {
  const MyOrdersState({
    this.status = FormzStatus.pure,
    this.exceptionError,
    this.orders = const [],
    this.page = 0,
    this.totalPages = 0,
    this.isLoadingMore = false,
  });

  final FormzStatus status; // first page
  final String? exceptionError;
  final List<OrderModel> orders;
  final int page;
  final int totalPages;
  final bool isLoadingMore;

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [
    status,
    exceptionError,
    orders,
    page,
    totalPages,
    isLoadingMore,
  ];

  MyOrdersState copyWith({
    FormzStatus? status,
    String? exceptionError,
    List<OrderModel>? orders,
    int? page,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return MyOrdersState(
      status: status ?? this.status,
      exceptionError: exceptionError ?? this.exceptionError,
      orders: orders ?? this.orders,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
