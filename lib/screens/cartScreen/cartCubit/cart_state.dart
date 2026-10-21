import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/screens/cartScreen/cartModel/cart_model.dart';

class CartState extends Equatable {
  const CartState({
    this.status = FormzStatus.pure,
    this.exceptionError,
    this.cart = const CartModel(),
    this.updateStatus = FormzStatus.pure,
  });

  final FormzStatus status; // loading the cart
  final String? exceptionError;
  final CartModel cart;
  final FormzStatus updateStatus; // change quantity / remove item

  @override
  List<Object?> get props => [status, exceptionError, cart, updateStatus];

  CartState copyWith({
    FormzStatus? status,
    String? exceptionError,
    CartModel? cart,
    FormzStatus? updateStatus,
  }) {
    return CartState(
      status: status ?? this.status,
      exceptionError: exceptionError ?? this.exceptionError,
      cart: cart ?? this.cart,
      updateStatus: updateStatus ?? this.updateStatus,
    );
  }
}
