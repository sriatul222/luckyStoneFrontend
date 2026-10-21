import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:luckystone/api/api_handler.dart';
import 'package:luckystone/api/urls.dart';
import 'package:luckystone/extra/flutter_toast.dart';
import 'package:luckystone/extra/json_parser.dart';
import 'package:luckystone/extra/my_utils.dart';
import 'package:luckystone/screens/addressScreen/addressModel/address_model.dart';
import 'package:luckystone/screens/cartScreen/cartModel/cart_model.dart';
import 'package:luckystone/screens/checkoutScreen/checkoutCubit/checkout_state.dart';
import 'package:luckystone/screens/orderDetailsScreen/orderDetailsModel/order_details_model.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(const CheckoutState());

  /// Loads the cart (order summary) and picks the default address.
  Future<void> getCheckoutData() async {
    if (state.status == FormzStatus.submissionInProgress) {
      return MyUtils.printLog('Checkout request already in progress');
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final List<dynamic> responses = await Future.wait<dynamic>([
        ApiHandler.handler.getApi(AppURLs.cartApi),
        ApiHandler.handler.getApi(AppURLs.addressesApi),
      ]);
      final cartResponse = responses[0];
      final addressResponse = responses[1];

      if (cartResponse?.statusCode == 200 &&
          cartResponse.data['success'] == true) {
        final addresses = addressResponse?.statusCode == 200
            ? parseList(addressResponse.data['data'], AddressModel.fromJson)
            : <AddressModel>[];
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            cart: CartModel.fromJson(cartResponse.data['data']),
            selectedAddress:
                state.selectedAddress ?? _defaultAddress(addresses),
          ),
        );
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          exceptionError: e.toString(),
        ),
      );
    }
  }

  AddressModel? _defaultAddress(List<AddressModel> addresses) {
    if (addresses.isEmpty) return null;
    return addresses.firstWhere(
      (address) => address.isDefault,
      orElse: () => addresses.first,
    );
  }

  void selectAddress(AddressModel address) {
    emit(state.copyWith(selectedAddress: address));
  }

  /// POST /orders buys everything in the cart at today's price.
  Future<void> placeOrder() async {
    final address = state.selectedAddress;
    if (state.orderStatus.isSubmissionInProgress) return;
    if (address == null) {
      FlutterToast.showToast('Please add a delivery address');
      return;
    }

    emit(state.copyWith(orderStatus: FormzStatus.submissionInProgress));

    try {
      final response = await ApiHandler.handler.postApi(AppURLs.ordersApi, {
        'address_id': address.id,
        'payment_method': state.paymentMethod,
      });

      if (response?.statusCode == 201 && response.data['success'] == true) {
        emit(
          state.copyWith(
            orderStatus: FormzStatus.submissionSuccess,
            placedOrder: OrderDetailsModel.fromJson(response.data['data']),
          ),
        );
      } else {
        emit(state.copyWith(orderStatus: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(
        state.copyWith(
          orderStatus: FormzStatus.submissionFailure,
          exceptionError: e.toString(),
        ),
      );
    }
  }
}
