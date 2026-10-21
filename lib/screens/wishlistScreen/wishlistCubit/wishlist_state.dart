import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/screens/homeScreen/homeModel/home_model.dart';

class WishlistState extends Equatable {
  const WishlistState({
    this.status = FormzStatus.pure,
    this.exceptionError,
    this.products = const [],
    this.removeStatus = FormzStatus.pure,
  });

  final FormzStatus status;
  final String? exceptionError;
  final List<ProductModel> products;
  final FormzStatus removeStatus;

  @override
  List<Object?> get props => [status, exceptionError, products, removeStatus];

  WishlistState copyWith({
    FormzStatus? status,
    String? exceptionError,
    List<ProductModel>? products,
    FormzStatus? removeStatus,
  }) {
    return WishlistState(
      status: status ?? this.status,
      exceptionError: exceptionError ?? this.exceptionError,
      products: products ?? this.products,
      removeStatus: removeStatus ?? this.removeStatus,
    );
  }
}
