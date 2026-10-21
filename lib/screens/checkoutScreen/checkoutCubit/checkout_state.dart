import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/screens/addressScreen/addressModel/address_model.dart';
import 'package:luckystone/screens/cartScreen/cartModel/cart_model.dart';
import 'package:luckystone/screens/orderDetailsScreen/orderDetailsModel/order_details_model.dart';

class CheckoutState extends Equatable {
  const CheckoutState({
    this.status = FormzStatus.pure,
    this.exceptionError,
    this.cart = const CartModel(),
    this.selectedAddress,
    this.paymentMethod = 'COD',
    this.orderStatus = FormzStatus.pure,
    this.placedOrder,
  });

  final FormzStatus status; // loading cart + addresses
  final String? exceptionError;
  final CartModel cart;
  final AddressModel? selectedAddress;
  final String paymentMethod; // COD (ONLINE is not built on the backend yet)
  final FormzStatus orderStatus; // place order request
  final OrderDetailsModel? placedOrder;

  @override
  List<Object?> get props => [
    status,
    exceptionError,
    cart,
    selectedAddress,
    paymentMethod,
    orderStatus,
    placedOrder,
  ];

  CheckoutState copyWith({
    FormzStatus? status,
    String? exceptionError,
    CartModel? cart,
    AddressModel? selectedAddress,
    String? paymentMethod,
    FormzStatus? orderStatus,
    OrderDetailsModel? placedOrder,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      exceptionError: exceptionError ?? this.exceptionError,
      cart: cart ?? this.cart,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderStatus: orderStatus ?? this.orderStatus,
      placedOrder: placedOrder ?? this.placedOrder,
    );
  }
}
