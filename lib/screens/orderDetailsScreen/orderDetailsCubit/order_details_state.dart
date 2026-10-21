import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/screens/orderDetailsScreen/orderDetailsModel/order_details_model.dart';

class OrderDetailsState extends Equatable {
  const OrderDetailsState({
    required this.orderId,
    this.status = FormzStatus.pure,
    this.exceptionError,
    this.details,
    this.cancelStatus = FormzStatus.pure,
  });

  final int orderId;
  final FormzStatus status;
  final String? exceptionError;
  final OrderDetailsModel? details;
  final FormzStatus cancelStatus;

  @override
  List<Object?> get props => [
    orderId,
    status,
    exceptionError,
    details,
    cancelStatus,
  ];

  OrderDetailsState copyWith({
    FormzStatus? status,
    String? exceptionError,
    OrderDetailsModel? details,
    FormzStatus? cancelStatus,
  }) {
    return OrderDetailsState(
      orderId: orderId,
      status: status ?? this.status,
      exceptionError: exceptionError ?? this.exceptionError,
      details: details ?? this.details,
      cancelStatus: cancelStatus ?? this.cancelStatus,
    );
  }
}
